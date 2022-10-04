import 'package:athaddakapp/model/user_model.dart';
import 'package:athaddakapp/screens/challenge_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChallengeCard extends StatefulWidget {
  const ChallengeCard({Key? key}) : super(key: key);

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {
  List _challenges = [];
  bool checkPart = true;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  fetchChallengeData() async {
    var _fireStoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await _fireStoreInstance.collection("challenges").get();

    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _challenges.add({
          "image-path": qn.docs[i]["image-path"],
          "description": qn.docs[i]["description"],
          "name": qn.docs[i]["name"],
          "date": qn.docs[i]["date"],
          "isTeam": qn.docs[i]["isTeam"],
          "price": qn.docs[i]["price"],
          "prize": qn.docs[i]["prize"],
          "location": qn.docs[i]["location"],
          "rules": qn.docs[i]["rules"],
          "members": qn.docs[i]["members"],
          "isLocked": qn.docs[i]["isLocked"],
        });
      }
    });
  }

  @override
  void initState() {
    fetchChallengeData();

    FirebaseFirestore.instance.collection("Users").doc(user!.uid).get().then(
        (value) => setState(
            () => this.loggedInUser = UserModel.fromMap(value.data())));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _challenges.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 4),
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (_challenges[index]["isLocked"] == "true") {
                showLockedDialog();
              } else {
                checkParticipation(index);
                if (checkPart == true) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ChallengeDetails(_challenges[index])));
                }
                checkPart = true;
              }
            },
            child: Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image(
                      image: NetworkImage(_challenges[index]["image-path"]),
                      fit: BoxFit.cover,
                      height: 150,
                      width: 350,
                      opacity: _challenges[index]["isLocked"] == "true"
                          ? AlwaysStoppedAnimation(.4)
                          : null,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "${_challenges[index]["name"]}\n",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                    child: Text(
                  "\n${_challenges[index]["date"]}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textDirection: TextDirection.ltr,
                )),
                Center(
                  child: SizedBox(
                    height: 130,
                    width: 130,
                    child: _challenges[index]["isLocked"] == "true"
                        ? Image.asset("assets/lock-icon.jpg")
                        : null,
                  ),
                )
              ],
            ),
          );
        });
  }

  checkParticipation(index) {
    for (int i = 0; i < loggedInUser.challengeMember!.length; i++) {
      if (loggedInUser.challengeMember![i] == _challenges[index]["name"]) {
        checkPart = false;
        showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                title: Center(
                  child: Text(
                    AppLocalizations.of(context)!.warning,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.warningContent,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () => Navigator.pop(context),
                      color: Colors.purple,
                      child: Text(
                        AppLocalizations.of(context)!.ok,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              );
            }));
      }
    }
  }

  showLockedDialog() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Center(
              child: Text(
                AppLocalizations.of(context)!.warning,
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.lockedChallengedialogContent,
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  color: Colors.purple,
                  child: Text(
                    AppLocalizations.of(context)!.ok,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        }));
  }
}
