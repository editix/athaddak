// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:athaddakapp/main.dart';
import 'package:athaddakapp/screens/forget_password.dart';
import 'package:athaddakapp/screens/home_screen.dart';
import 'package:athaddakapp/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Declaring the login form key in order to identify its fields and allow validating the fields
  final _formKey = GlobalKey<FormState>();

  //Declaring an instances of TextEditingController to the login form fields.
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //Delaring an instance of firebase authentication

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //Designing the input field of the email address
    final emailField = TextFormField(
      //Adding a listener for the email value controller.
      controller: emailController,
      autofocus: false,
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        emailController.text = value!;
      },
      //Using decoration to start designing the app look and feel.
      // ignore: prefer_const_constructors
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: AppLocalizations.of(context)!.emailHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
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

    //Designing the input field of the password
    final passwordField = TextFormField(
      controller: passwordController,
      autofocus: false,
      autocorrect: false,
      enableSuggestions: false,
      obscureText: true,
      textInputAction: TextInputAction.done,
      onSaved: (value) {
        passwordController.text = value!;
      },
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: AppLocalizations.of(context)!.passwordHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
    );

    //Creating and Designing the Login button Using Material widget as a wrapper because it contains properties useful for creating button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.purple,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        // ignore: prefer_const_constructors
        child: Text(
          AppLocalizations.of(context)!.signInButtonText,
          textAlign: TextAlign.center,
          // ignore: prefer_const_constructors
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString('email', emailController.text);
          signIn(emailController.text, passwordController.text);
        },
      ),
    );

    //rendering the design of the login screen with scaffold widgets.
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          //Use the SingleChildScrollView as a wrapper to ensure scrolling in case scorrling is needed.
          child: SingleChildScrollView(
            //wrap the elements with Container to provide flexibility in designing the elements.
            child: Container(
              color: Colors.white,
              //use the form as a container of the input fields as it is a login form.
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  //give the form wrapper the key value to tell flutter that this is the form design for your form functions.
                  key: _formKey,
                  //use the column to show the elements in vertical array.
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //Use children property inside the column to specify list of widgets
                    children: <Widget>[
                      //Creating a space between widgets using invisible box
                      SizedBox(
                        child: Image.asset("assets/logo-3.PNG"),
                        height: 200,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      emailField,
                      SizedBox(
                        height: 25,
                      ),
                      passwordField,
                      SizedBox(
                        height: 25,
                      ),
                      loginButton,
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ForgetPasswordScreen()));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forgetPasswordText,
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      //GestureDetector creates an invisible space, this space can detect user gestures like tapping.
                      GestureDetector(
                        //onTap is a gesture that user might do in the GestureDetector space which perform actopn on tapping.
                        onTap: () {
                          //Navigator here is used with push function to navigate to new screen.
                          Navigator.push(
                              context,
                              //MaterialPageRoute is a model that creates a transition animation between routes (screens)
                              MaterialPageRoute(
                                  builder: (context) => RegistrationScreen()));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.signUpText,
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                if (AppLocalizations.of(context)!.signUpText ==
                                    "مستخدم جديد") {
                                  return MyApp.of(context)!.setLocale(
                                      Locale.fromSubtags(languageCode: 'en'));
                                } else {
                                  return MyApp.of(context)!.setLocale(
                                      Locale.fromSubtags(languageCode: 'ar'));
                                }
                              },
                              child: AppLocalizations.of(context)!.signUpText ==
                                      "مستخدم جديد"
                                  ? Text("English")
                                  : Text("عربي")),
                          Text(AppLocalizations.of(context)!.languageChange),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Sign in validation function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()))
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}
