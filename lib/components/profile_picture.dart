import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/user_model.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("Users").doc(user!.uid).get().then(
        (value) => setState(
            () => this.loggedInUser = UserModel.fromMap(value.data())));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Align(
        alignment: Alignment.topCenter,
        child: Stack(children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
                border: Border.all(width: 4, color: Colors.white),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 10))
                ],
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage("${loggedInUser.profileImage}"),
                )),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 4,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  color: Colors.purple,
                ),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()));
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              )),
        ]),
      ),
    );
  }

//Imge Picker and BottomSheet logic
  Widget bottomSheet() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            'Choose Profile Picture',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  IconButton(
                    iconSize: 70,
                    icon: const Icon(
                      Icons.camera,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      uploadImageCamera();
                      Navigator.pop(context);
                    },
                  ),
                  Text('Camera')
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Column(
                children: [
                  IconButton(
                    iconSize: 70,
                    icon: const Icon(Icons.image, color: Colors.purple),
                    onPressed: () {
                      uploadImageGallery();
                      Navigator.pop(context);
                    },
                  ),
                  Text('Gallery'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  uploadImageCamera() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _userStorage =
        FirebaseFirestore.instance.collection("Users").doc(user!.uid);
    final _imagePicker = ImagePicker();
    PickedFile? image;
    //Check Permissions
    await Permission.camera.request();

    var permissionStatus = await Permission.camera.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _imagePicker.getImage(source: ImageSource.camera);
      var file = File(image!.path);

      if (image != null) {
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('users_images/${loggedInUser.name}.jpg')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
          loggedInUser.profileImage = imageUrl;
          _userStorage.update({'profileImage': imageUrl});
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print("Nothing....!");
    }
  }

  uploadImageGallery() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _userStorage =
        FirebaseFirestore.instance.collection("Users").doc(user!.uid);
    final _imagePicker = ImagePicker();
    PickedFile? image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _imagePicker.getImage(source: ImageSource.gallery);
      var file = File(image!.path);

      //Upload to Firebase
      var snapshot = await _firebaseStorage
          .ref()
          .child('users_images/${loggedInUser.name}.jpg')
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        loggedInUser.profileImage = imageUrl;
        _userStorage.update({'profileImage': imageUrl});
      });
    }
  }
}
