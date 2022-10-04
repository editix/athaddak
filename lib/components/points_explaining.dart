import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class explainPoints extends StatefulWidget {
  const explainPoints({Key? key}) : super(key: key);

  @override
  State<explainPoints> createState() => _explainPointsState();
}

class _explainPointsState extends State<explainPoints> {
  String explain = '''
نقاط اتحداك تفيد المشاركين في عدة اماكن في التطبيق وبالمستقبل القريب سيستفيد منها المشترك بشكل أكبر ومادي

 في البداية عند الإشتراك بالتطبيق يحصل المشترك على 20 نقطة وعند الإشتراك في اي تحدي يحصل المشترك على 20 نقطة اضافية 
عند الوصول الى مئة نقطة بامكان المشترك استبدالها بالدخول الى اي تحدي مجانا او استبدال النقاط بطاقية او تي شيرت أتحداك''';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("النقاط"),
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
            Center(child: Image.asset("assets/logo-3.PNG")),
            SizedBox(
              height: 50,
            ),
            aboutExpansion("نقاط أتحداك", explain),
          ],
        ));
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
}
