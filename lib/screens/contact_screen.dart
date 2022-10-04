import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.contactTitle),
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
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                height: 200,
                child: Image.asset("assets/logo-3.PNG"),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            contactUsButtons(
                Icons.phone_outlined, AppLocalizations.of(context)!.callUs),
            SizedBox(
              height: 15,
            ),
            contactUsButtons(
                Icons.whatsapp, AppLocalizations.of(context)!.whatsApp),
            SizedBox(
              height: 15,
            ),
            contactUsButtons(
                Icons.email_outlined, AppLocalizations.of(context)!.email),
            SizedBox(
              height: 50,
            ),
            Text(AppLocalizations.of(context)!.copyrights)
          ],
        ),
      ),
    );
  }

  contactUsButtons(IconData icon, String text) {
    return InkWell(
      onTap: () {
        switch (text) {
          case "Email":
            _openGmail();
            break;
          case "WhatsApp":
            _launchWhatsapp();
            break;
          case "Call Us":
            _directCall();
            break;
          case "اتصل بنا":
            _directCall();
            break;
          case "واتساب":
            _launchWhatsapp();
            break;
          case "ايميل":
            _openGmail();
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.only(right: 12, left: 10),
        width: 300,
        height: 60,
        decoration: BoxDecoration(
            color: Colors.purple, borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  //Call Directly
  _directCall() {
    launchUrl(Uri.parse('tel:00962785522213'));
  }

  //Open WhatsApp
  _launchWhatsapp() {
    launchUrl(Uri.parse("whatsapp://send?phone=+962797809910"));
  }

  //open email
  _openGmail() {
    final Uri emailLaunchUri =
        Uri(scheme: 'mailto', path: 'info@athaddak.com', queryParameters: {
      'subject': 'Inquiry',
    });

    launchUrl(emailLaunchUri);
  }
}
