import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MajorChallange extends StatefulWidget {
  const MajorChallange({Key? key}) : super(key: key);

  @override
  State<MajorChallange> createState() => _MajorChallangeState();
}

class _MajorChallangeState extends State<MajorChallange> {
  String img = "";

  fetchMajorChallengeImage() async {
    var _fireStoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn =
        await _fireStoreInstance.collection("majorChallenges").get();

    setState(() {
      img = qn.docs[0]["source"];
    });

    return qn.docs;
  }

  @override
  void initState() {
    fetchMajorChallengeImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(img, height: 150, fit: BoxFit.fill),
        ],
      ),
    );
  }
}
