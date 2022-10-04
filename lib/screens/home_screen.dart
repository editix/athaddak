import 'package:athaddakapp/components/challengeCard.dart';
import 'package:athaddakapp/model/user_model.dart';
import 'package:athaddakapp/screens/points_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/ads_banner.dart';
import '../components/major_challenge.dart';
import 'navigation_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("Users").doc(user!.uid).get().then(
        (value) => setState(
            () => this.loggedInUser = UserModel.fromMap(value.data())));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: Text("${loggedInUser.points}",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                    GestureDetector(
                      child: FaIcon(
                        FontAwesomeIcons.coins,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PointsScreen())),
                    ),
                  ],
                ),
              ),
            ],
            backgroundColor: Colors.purple,
            title: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Image.asset(
                "assets/appBar.PNG",
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              AdsBanner(),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8, bottom: 5),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.challenges + " ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      AppLocalizations.of(context)!.clickToParticipate,
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ),
              Expanded(child: ChallengeCard()),
            ],
          ),
          drawer: NavigationDrawer()),
    );
  }
}
