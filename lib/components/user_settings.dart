import 'package:athaddakapp/main.dart';
import 'package:athaddakapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login_screen.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  var _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final matchPasswordController = TextEditingController();
  final userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("Users").doc(user!.uid).get().then(
        (value) => setState(
            () => this.loggedInUser = UserModel.fromMap(value.data())));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        settingsInfo(
            Icons.account_circle, AppLocalizations.of(context)!.changeName),
        SizedBox(
          height: 15,
        ),
        settingsInfo(Icons.lock, AppLocalizations.of(context)!.changePassword),
        SizedBox(
          height: 15,
        ),
        settingsInfo(Icons.language, AppLocalizations.of(context)!.language),
        SizedBox(
          height: 15,
        ),
        settingsInfo(Icons.share, AppLocalizations.of(context)!.shareApp),
        SizedBox(
          height: 15,
        ),
        settingsInfo(Icons.logout, AppLocalizations.of(context)!.logOut)
      ],
    );
  }

  //Settings list design
  Widget settingsInfo(IconData icon, String text) {
    return InkWell(
        onTap: () {
          switch (text) {
            case "Change Name":
              changeUserName();
              break;
            case "Change Password":
              changePassword();
              break;
            case "Language":
              changeLanguage();
              break;
            case "Share App":
              shareApp();
              break;
            case "Log out":
              userLogout(context);
              break;
            case "تغيير الإسم":
              changeUserName();
              break;
            case "تغيير كلمة السر":
              changePassword();
              break;
            case "اللغة":
              changeLanguage();
              break;
            case "شارك التطبيق":
              shareApp();
              break;
            case "تسجيل الخروج":
              userLogout(context);
              break;
          }
        },
        child: Container(
          width: 310,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.purple,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 17),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.purple,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  //Change Password Function
  changePassword() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
                    AppLocalizations.of(context)!.changePasswordDialogTitle)),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    textAlign: TextAlign.center,
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return (AppLocalizations.of(context)!
                            .passwordValidationEmpty);
                      }
                      if (!regex.hasMatch(value)) {
                        return (AppLocalizations.of(context)!
                            .passwordValidationValid);
                      }
                    },
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!
                            .changePasswordDialogHint,
                        suffixIcon:
                            Icon(Icons.lock_outline, color: Colors.purple)),
                  ),
                  TextFormField(
                    controller: matchPasswordController,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!
                            .changePasswordDialogConfirmHint,
                        suffixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.purple,
                        )),
                    validator: ((value) {
                      return newPasswordController.text == value
                          ? null
                          : AppLocalizations.of(context)!
                              .confirmPasswordValidation;
                    }),
                  ),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          user!.updatePassword(newPasswordController.text);
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: "Password Changed Successfully .. :)");
                        }
                      },
                      child: Text(
                          AppLocalizations.of(context)!.resetPasswordButton))
                ],
              ),
            ),
          );
        });
  }

  //Change Username Function
  changeUserName() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child:
                    Text(AppLocalizations.of(context)!.changeNameDialogTitle)),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: userNameController,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return ("Please Enter Name ... !");
                      }
                    }),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.chanheNameDialogHint,
                        suffixIcon: Icon(
                          Icons.account_circle,
                          color: Colors.purple,
                        )),
                  ),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          var collection =
                              FirebaseFirestore.instance.collection('Users');
                          collection
                              .doc(user!.uid)
                              .update({"name": userNameController.text});
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: "username changed successfully ... :)");
                        }
                      },
                      child: Text("تغيير"))
                ],
              ),
            ),
          );
        });
  }

  //Sharing app link Method
  shareApp() async {
    const urlPreview = 'https://www.youtube.com/watch?v=OaCU_z9eGOk';
    await Share.share(
        "Download Athaddak now and access lot of fun challenges and WIN !!\n\n$urlPreview");
  }

  //Logout Function
  Future<void> userLogout(BuildContext context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove('email');
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  changeLanguage() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
                    AppLocalizations.of(context)!.changeLanguageDialogTitle)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MaterialButton(
                  onPressed: () => MyApp.of(context)!
                      .setLocale(Locale.fromSubtags(languageCode: 'en')),
                  color: Colors.purple,
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width / 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "English",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  onPressed: () => MyApp.of(context)!
                      .setLocale(Locale.fromSubtags(languageCode: 'ar')),
                  color: Colors.purple,
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width / 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "عربي",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
