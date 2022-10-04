import 'package:athaddakapp/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChallengeDetails extends StatefulWidget {
  var _challenge;
  ChallengeDetails(this._challenge);

  @override
  State<ChallengeDetails> createState() => _ChallengeDetailsState();
}

class _ChallengeDetailsState extends State<ChallengeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget._challenge['name']),
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
            SizedBox(
                height: 295,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget._challenge['image-path'],
                  fit: BoxFit.cover,
                )),
            SizedBox(
              height: 10,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  challengeHead(AppLocalizations.of(context)!.entrance,
                      Icons.attach_money, widget._challenge['price']),
                  challengeHead(AppLocalizations.of(context)!.players,
                      Icons.groups, widget._challenge['isTeam']),
                  challengeHead(AppLocalizations.of(context)!.prize,
                      Icons.card_giftcard, widget._challenge['prize']),
                ],
              ),
            ),
            SizedBox(height: 15),
            challengeAbout(AppLocalizations.of(context)!.aboutChallenge,
                widget._challenge['description']),
            challengeRules(AppLocalizations.of(context)!.rules,
                widget._challenge["rules"]),
            challengeAbout(AppLocalizations.of(context)!.location,
                widget._challenge["location"]),
          ],
        ),
      ),
      bottomNavigationBar: MaterialButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => PaymentScreen(
                      widget._challenge['name'],
                      widget._challenge['price'],
                      widget._challenge['date']))));
        },
        color: Colors.purple,
        textColor: Colors.white,
        height: 50,
        child: Text(
          AppLocalizations.of(context)!.participate,
          style: TextStyle(
            fontSize: 19,
          ),
        ),
      ),
    );
  }

  challengeHead(String text, IconData icon, String value) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 4,
        ),
        Icon(
          icon,
          size: 50,
        ),
        SizedBox(
          height: 4,
        ),
        Text(value,
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  challengeAbout(String title, String desc) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.purple,
          height: 35,
          child: Center(
              child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          )),
        ),
        Container(
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  challengeRules(String title, List<dynamic> rules) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.purple,
          height: 35,
          child: Center(
              child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          )),
        ),
        Container(
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              rules
                  .map((rule) => rule + "\n")
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
        ),
      ],
    );
  }
}
