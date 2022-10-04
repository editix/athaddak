import 'dart:ffi';

import 'package:athaddakapp/model/user_model.dart';
import 'package:athaddakapp/screens/about_screen.dart';
import 'package:athaddakapp/screens/all_challenges_screen.dart';
import 'package:athaddakapp/screens/contact_screen.dart';
import 'package:athaddakapp/screens/home_screen.dart';
import 'package:athaddakapp/screens/my_challenges.dart';
import 'package:athaddakapp/screens/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
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
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.purple,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsScreen()));
          },
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, bottom: 24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage("${loggedInUser.profileImage}"),
                ),
                SizedBox(height: 12),
                Text(
                  "${loggedInUser.name}",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text("${loggedInUser.email}",
                    style: TextStyle(fontSize: 17, color: Colors.white)),
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: EdgeInsets.all(20),
        child: Wrap(
          runSpacing: 5,
          children: [
            ListTile(
                leading: Icon(Icons.home_outlined),
                title: Text(
                  AppLocalizations.of(context)!.homepage,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }),
            ListTile(
              leading: Icon(Icons.flag_outlined),
              title: Text(
                AppLocalizations.of(context)!.myChallenge,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyChallenges()));
              },
            ),
            ListTile(
              leading: Icon(Icons.flag_circle_outlined),
              title: Text(
                AppLocalizations.of(context)!.allChallenges,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const allChallenges()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text(
                AppLocalizations.of(context)!.settings,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.question_mark_outlined),
              title: Text(
                AppLocalizations.of(context)!.about,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUs()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.phone_outlined),
              title: Text(
                AppLocalizations.of(context)!.contact,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactUs()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.followus,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.facebook,
                    size: 40,
                  ),
                  color: Colors.purple,
                  onPressed: () {
                    launchUrl(
                        Uri.parse('https://www.facebook.com/AthaddakApp/'));
                  },
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.instagram,
                    size: 40,
                  ),
                  color: Colors.purple,
                  onPressed: () {
                    launchUrl(Uri.parse(
                        'https://instagram.com/athaddak.app?igshid=YmMyMTA2M2Y='));
                  },
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.twitter,
                    size: 40,
                  ),
                  color: Colors.purple,
                  onPressed: () {
                    launchUrl(Uri.parse('https://twitter.com/Athaddak_app'));
                  },
                ),
              ],
            ),
          ],
        ),
      );
}
