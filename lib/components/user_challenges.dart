import 'package:athaddakapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class userChallenges extends StatefulWidget {
  const userChallenges({Key? key}) : super(key: key);

  @override
  State<userChallenges> createState() => _userChallengesState();
}

class _userChallengesState extends State<userChallenges> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          itemCount: loggedInUser.challengeHistory?.length ?? 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: MediaQuery.of(context).size.width /
                  4 /
                  (MediaQuery.of(context).size.height / 17)),
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.purple, border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        loggedInUser.challengeHistory![index]["name"],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        loggedInUser.challengeHistory![index]["date"] +
                            "\n\n" +
                            loggedInUser.challengeHistory![index]["isWin"],
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
