import 'package:another_flushbar/flushbar.dart';
import 'package:athaddakapp/screens/home_screen.dart';
import 'package:athaddakapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  String _email = "";

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      //Adding a listener for the email value controller.
      autofocus: false,
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (value) {
        _email = value;
      },
      //Using decoration to start designing the app look and feel.
      // ignore: prefer_const_constructors
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: AppLocalizations.of(context)!.emailHint,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter your Email Address";
        }

        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.resetPasswordTitle),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          emailField,
          SizedBox(height: 20),
          MaterialButton(
            onPressed: () {
              if (_email.isEmpty) {
                Flushbar(
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.purple,
                  messageText: Text(
                    AppLocalizations.of(context)!.enterEmailMessage,
                    style: TextStyle(color: Colors.white),
                  ),
                ).show(context);
              } else {
                FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
                changePassword();
              }
            },
            color: Colors.purple,
            height: 50,
            child: Text(
              AppLocalizations.of(context)!.resetPasswordButton,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  changePassword() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.resetPasswordTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.resetPasswordDialog),
                SizedBox(height: 10),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  color: Colors.purple,
                  height: 40,
                  child: Text(
                    AppLocalizations.of(context)!.resetPasswordDialogButton,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        });
  }
}
