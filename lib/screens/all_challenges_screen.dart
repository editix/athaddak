import 'package:athaddakapp/components/challengeCard.dart';
import 'package:athaddakapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'navigation_drawer.dart';

class allChallenges extends StatefulWidget {
  const allChallenges({Key? key}) : super(key: key);

  @override
  State<allChallenges> createState() => _allChallengesState();
}

class _allChallengesState extends State<allChallenges> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.allChallenges,
          style: TextStyle(color: Colors.white),
        ),
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
        children: [
          Expanded(child: ChallengeCard()),
        ],
      ),
    );
  }
}
