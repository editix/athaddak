import 'package:athaddakapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("Users").doc(user!.uid).get().then(
        (value) => setState(
            () => this.loggedInUser = UserModel.fromMap(value.data())));
  }

  Widget userStats(BuildContext context, int? value, String text) {
    return MaterialButton(
      onPressed: () {},
      padding: EdgeInsets.symmetric(vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toString(),
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          Text(text,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        ],
      ),
    );
  }

  Widget verticalLine() => Container(
        height: 20,
        child: VerticalDivider(
          thickness: 1,
          color: Colors.purple,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${loggedInUser.name}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 5,
        ),
        Text("${loggedInUser.email}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        SizedBox(
          height: 30,
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              userStats(context, loggedInUser.challenges,
                  AppLocalizations.of(context)!.challenge),
              verticalLine(),
              userStats(context, loggedInUser.winnings,
                  AppLocalizations.of(context)!.wins),
              verticalLine(),
              userStats(context, loggedInUser.events,
                  AppLocalizations.of(context)!.events)
            ],
          ),
        )
      ],
    );
  }
}
