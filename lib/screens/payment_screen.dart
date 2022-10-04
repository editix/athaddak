import 'package:another_flushbar/flushbar.dart';
import 'package:athaddakapp/model/user_model.dart';
import 'package:athaddakapp/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentScreen extends StatefulWidget {
  String _challengeName = "";
  String _challengePrice = "";
  String _challengeDate = "";
  PaymentScreen(this._challengeName, this._challengePrice, this._challengeDate);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool? checked = false;
  int _value = 2;
  String dialogTitle = "";
  String dialogContent = "";

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
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                replacePoints();
              },
              child: Text(
                AppLocalizations.of(context)!.replacePoints,
                style: TextStyle(color: Colors.white),
              ))
        ],
        title: Text(AppLocalizations.of(context)!.paymentTitle),
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _value = 1;
                });
              },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: _value == 1 ? .9 : .1,
                child: Container(
                  height: 200,
                  width: 200,
                  child: Image(
                    image: AssetImage("assets/zainCashLogo.png"),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _value = 2;
                });
              },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: _value == 2 ? .9 : .1,
                child: Container(
                  height: 200,
                  width: 200,
                  child: Image(
                    image: AssetImage("assets/OrangeMoneyLogo.png"),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _value = 3;
                });
              },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: _value == 3 ? .9 : .1,
                child: Container(
                  height: 200,
                  width: 200,
                  child: Image(
                    image: AssetImage("assets/UWalletLogo.jpg"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width / 1.52,
          color: Colors.purple,
          height: 50,
          onPressed: () {
            if (_value == 1) {
              dialogTitle = AppLocalizations.of(context)!.zainCashTitle;
              dialogContent = AppLocalizations.of(context)!.zainCashContent;
              paymentDialog(dialogTitle, dialogContent);
            } else if (_value == 2) {
              dialogTitle = AppLocalizations.of(context)!.orangeMoneyTitle;
              dialogContent = AppLocalizations.of(context)!.orangeMoneyContent;
              paymentDialog(dialogTitle, dialogContent);
            } else if (_value == 3) {
              dialogTitle = AppLocalizations.of(context)!.umniahTitle;
              dialogContent = AppLocalizations.of(context)!.umniahContent;
              paymentDialog(dialogTitle, dialogContent);
            }
          },
          child: Text(
            AppLocalizations.of(context)!.payNow,
            style: TextStyle(
                color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  paymentDialog(String dialogTitle, String dialogContent) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Center(
                child: Text(
              dialogTitle,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            )),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dialogContent,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: checked,
                          onChanged: (val) {
                            setState(() {
                              checked = val;
                            });
                          }),
                      Text(AppLocalizations.of(context)!.paymentCheckbox)
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      "${AppLocalizations.of(context)!.joiningFee} ${widget._challengePrice}"),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    height: 50,
                    onPressed: () {
                      if (checked == true) {
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(user!.uid)
                            .update({
                          'points': loggedInUser.points! + 20,
                          'challenges': loggedInUser.challenges! + 1,
                          'challengeMember':
                              FieldValue.arrayUnion([widget._challengeName]),
                          'challengeHistory': FieldValue.arrayUnion([
                            {
                              "name": widget._challengeName,
                              "date": widget._challengeDate,
                              "isWin": ""
                            }
                          ]),
                        });
                        FirebaseFirestore.instance
                            .collection("challenges")
                            .doc(widget._challengeName)
                            .update({
                          "members": FieldValue.arrayUnion([loggedInUser.phone])
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => HomeScreen())));
                      } else {
                        print("Nothing");
                      }
                    },
                    color: checked == false
                        ? Colors.green.withOpacity(0.1)
                        : Colors.green,
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.joinNow,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    height: 50,
                    onPressed: () {
                      checked = false;
                      Navigator.pop(context);
                    },
                    color: Colors.red,
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.cancle,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ],
              );
            }),
          );
        }));
  }

  replacePoints() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Center(child: Text(AppLocalizations.of(context)!.replacePoints)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.pointsReplaceContent,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.requiredPoints,
              ),
              Text(
                "${AppLocalizations.of(context)!.existPoints} ${loggedInUser.points}",
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                height: 45,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                minWidth: MediaQuery.of(context).size.width / 1.60,
                onPressed: () {
                  if (loggedInUser.points! >= 100) {
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(user!.uid)
                        .update({
                      'points': loggedInUser.points! - 100,
                      'challenges': loggedInUser.challenges! + 1,
                      'challengeMember':
                          FieldValue.arrayUnion([widget._challengeName])
                    });
                    FirebaseFirestore.instance
                        .collection("challenges")
                        .doc(widget._challengeName)
                        .update({
                      "members": FieldValue.arrayUnion([loggedInUser.phone])
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => HomeScreen())));
                  } else {
                    Flushbar(
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.purple,
                      messageText: Text(
                        AppLocalizations.of(context)!.noPointsMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                    ).show(context);
                  }
                },
                color: Colors.green,
                child: Text(
                  AppLocalizations.of(context)!.confirm,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                height: 45,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                minWidth: MediaQuery.of(context).size.width / 1.60,
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.red,
                child: Text(
                  AppLocalizations.of(context)!.cancle,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
