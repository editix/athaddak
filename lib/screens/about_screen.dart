import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String whoWeAre = '';
  String appIdea = '';
  List _teamInfo = [];

  fetchAboutData() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection("aboutUs").get();

    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        whoWeAre = qn.docs[i]["whoWeAre"];
        appIdea = qn.docs[i]["appIdea"];
        for (int j = 0; j < qn.docs[i]["teamInfo"].length; j++) {
          _teamInfo.add(qn.docs[i]["teamInfo"][j]);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchAboutData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("عن التطبيق"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/amman.jpg"),
            SizedBox(
              height: 10,
            ),
            aboutExpansion("من نحن؟", whoWeAre),
            SizedBox(
              height: 10,
            ),
            aboutExpansion("فكرة أتحداك", appIdea),
            SizedBox(
              height: 10,
            ),
            teamInformation("معلومات الفريق", _teamInfo),
          ],
        ),
      ),
    );
  }

  aboutExpansion(String titleText, String bodyText) {
    return ExpansionTile(
      initiallyExpanded: false,
      collapsedBackgroundColor: Colors.purple,
      collapsedTextColor: Colors.white,
      collapsedIconColor: Colors.white,
      title: Text(
        titleText,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 13, right: 10),
          child: Text(
            bodyText,
            textDirection: TextDirection.rtl,
            style: TextStyle(letterSpacing: 0.2),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  teamInformation(String titleText, List information) {
    return ExpansionTile(
      initiallyExpanded: false,
      collapsedBackgroundColor: Colors.purple,
      collapsedTextColor: Colors.white,
      collapsedIconColor: Colors.white,
      title: Text(
        titleText,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            information
                .map((info) => info + "\n")
                .toList()
                .toString()
                .replaceAll('[', ' ')
                .replaceAll(']', '')
                .replaceAll(',', ''),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              height: 2,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
