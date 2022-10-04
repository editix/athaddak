// ignore_for_file: prefer_const_constructors, duplicate_ignore
import 'dart:io';
import 'package:athaddakapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //Declaring firebase authentication instance
  final _auth = FirebaseAuth.instance;
  //declare the registration form identifier (GlobalKey) to uniquely identify the form fields and validate them.
  final _formKey = GlobalKey<FormState>();
  //declaring fields controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  //declaring list items for the drop down button
  List<String> provinces = [
    'عمان',
    'إربد',
    'الزرقاء',
    'المفرق',
    'الطفيلة',
    'عجلون',
    'معان',
    'الكرك',
    'مادبا',
    'العقبة',
    'البلقاء',
    'جرش'
  ];
  String dropDownValue = 'عمان';
  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      controller: nameController,
      autofocus: false,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)!.nameValidationEmpty;
        }
        if (!RegExp('^[a-z]{3,50}').hasMatch(value)) {
          return AppLocalizations.of(context)!.nameValidationValid;
        }
        return null;
      },
      onSaved: (value) {
        nameController.text = value!;
      },
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: AppLocalizations.of(context)!.fullName,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final emailField = TextFormField(
      controller: emailController,
      autofocus: false,
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)!.mailValidationEmpty;
        }

        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return (AppLocalizations.of(context)!.mailValidationValid);
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: AppLocalizations.of(context)!.userMail,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final phoneField = TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      autofocus: false,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)!.phoneValidationEmpty;
        }
      },
      onSaved: (value) {
        phoneController.text = value!;
      },
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: AppLocalizations.of(context)!.phoneNumber,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //Declaring and designing a dropdown menu button that holds the countries list.
    final provincesField = DropdownButtonFormField<String>(
      value: dropDownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropDownValue = newValue!;
        });
      },
      items: provinces.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: SizedBox(
              width: 100.0,
              child: Text(value, textAlign: TextAlign.center),
            ));
      }).toList(),
      elevation: 4,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.flag_circle),
        labelText: AppLocalizations.of(context)!.chooseProvinence,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final passwordField = TextFormField(
      controller: passwordController,
      autofocus: false,
      autocorrect: false,
      enableSuggestions: false,
      obscureText: true,
      textInputAction: TextInputAction.done,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,20}$');
        if (value!.isEmpty) {
          return (AppLocalizations.of(context)!.passwordValidationEmpty);
        }
        if (!regex.hasMatch(value)) {
          return (AppLocalizations.of(context)!.passwordValidationValid);
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: AppLocalizations.of(context)!.passwordUser,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final confirmPasswordField = TextFormField(
      controller: confirmPasswordController,
      autofocus: false,
      autocorrect: false,
      enableSuggestions: false,
      obscureText: true,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (confirmPasswordController.text != passwordController.text) {
          return AppLocalizations.of(context)!.confirmPasswordValidation;
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: AppLocalizations.of(context)!.confirmPassword,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //Date picker for birth of date field
    final birthDateField = DateTimeField(
      controller: dateController,
      format: DateFormat("dd-MM-yyyy"),
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            initialDate: currentValue ?? DateTime.now(),
            firstDate: DateTime(1920),
            lastDate: DateTime(2030));
        return date;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: AppLocalizations.of(context)!.birthDate,
        prefixIcon: Icon(Icons.calendar_month),
      ),
    );

    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.purple,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        // ignore: prefer_const_constructors
        child: Text(
          AppLocalizations.of(context)!.registerButtonText,
          textAlign: TextAlign.center,
          // ignore: prefer_const_constructors
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          signUp(emailController.text, passwordController.text);
        },
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.purple,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      nameField,
                      SizedBox(
                        height: 20,
                      ),
                      emailField,
                      SizedBox(
                        height: 20,
                      ),
                      provincesField,
                      SizedBox(
                        height: 20,
                      ),
                      phoneField,
                      SizedBox(
                        height: 20,
                      ),
                      passwordField,
                      SizedBox(
                        height: 20,
                      ),
                      confirmPasswordField,
                      SizedBox(
                        height: 20,
                      ),
                      birthDateField,
                      SizedBox(
                        height: 20,
                      ),
                      signUpButton,
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Sign up method (when user clicks on sign up this method will be invoked)
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDataToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDataToFirestore() async {
    //Creating Instance of firestore from firebase
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    //Creating an instance of UserModel Class
    UserModel userModel = UserModel();

    //providing the fields values to the user model class
    userModel.uid = user!.uid;
    userModel.name = nameController.text;
    userModel.email = emailController.text;
    userModel.phone = phoneController.text;
    userModel.province = dropDownValue;
    userModel.dateOfBirth = dateController.text;
    userModel.challengeHistory = [];
    userModel.challengeMember = [];
    userModel.profileImage =
        'https://firebasestorage.googleapis.com/v0/b/athaddak-bf02c.appspot.com/o/default_picture%2FBlank-Avatar.png?alt=media&token=47255868-37a0-4a55-8bc4-1d1ef5599ded';
    userModel.challenges = 0;
    userModel.winnings = 0;
    userModel.events = 0;
    userModel.points = 20;

    //Sending data to firestore
    await firebaseFirestore
        .collection("Users")
        .doc(user.uid)
        .set(userModel.toMap());

    //Account Created Successfuly message
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.createdSuccessfully);

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}
