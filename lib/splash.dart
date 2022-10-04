import 'dart:async';
import 'dart:io';

import 'package:athaddakapp/screens/home_screen.dart';
import 'package:athaddakapp/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var finalEmail;

  @override
  void initState() {
    // TODO: implement initState
    final StreamSubscription<InternetConnectionStatus> listener =
        InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            getValidationData().whenComplete(() async {
              await Future.delayed(Duration(milliseconds: 4000));
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        finalEmail == null ? LoginScreen() : HomeScreen(),
                  ));
            });
            break;
          case InternetConnectionStatus.disconnected:
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.warning),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.noConnection),
                        SizedBox(
                          height: 40,
                        ),
                        MaterialButton(
                          onPressed: () => exit(0),
                          color: Colors.purple,
                          child: Text(
                            AppLocalizations.of(context)!.ok,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  );
                });
            break;
        }
      },
    );

    super.initState();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      finalEmail = obtainedEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.8,
            child: Image.asset(
              "assets/appBar.PNG",
            ),
          )
        ],
      ),
    );
  }
}
