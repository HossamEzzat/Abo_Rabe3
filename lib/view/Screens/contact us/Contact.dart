import 'package:flutter/material.dart';
import 'package:rabe3/view/Screens/Login/SignIn.dart';
import 'package:contactus/contactus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../Homescreen/HomeScreen.dart';
class Contactus extends StatefulWidget {
   Contactus({Key? key,this.context}) : super(key: key);
BuildContext? context;
  @override
  State<Contactus> createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor:  Color(0xff0e1712),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  widget.context!,
                  MaterialPageRoute(builder: (context) => SignIn()),(route) => false,
                );
              },
              child: Icon(Icons.add_moderator),
            ),
            GestureDetector(
              onTap: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("isUserLoggedIn");
                prefs.remove("isAdmin");
                Navigator.pushAndRemoveUntil(
                  widget.context!,
                  PageTransition(
                    child: HomeScreen(),
                    type: PageTransitionType.bottomToTop,
                  ),(route) => false,
                );
              },
              child: Icon(Icons.supervised_user_circle),
            ),
          ],
        ),
        backgroundColor: Color(0xff0e1712),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 0.05 * screenWidth), // Responsive padding
          child: ContactUs(
            dividerColor: Color(0xffb09e54),
            logo: AssetImage('assets/lanch.jpg'),
            email: 'mahmoudrabeea992@gmail.com',
            companyName: 'مشويات ابو ربيع',
            website: 'https://www.facebook.com/AboRabi3Restaurant',
            phoneNumber: '+201140114357',
            phoneNumber2:'+201003043058',
            phoneNumberText:'01140114357',
            phoneNumberText2:'01003043058',
            companyFontSize: 0.08 * screenWidth, // Responsive font size
            dividerThickness: 0.02 * screenWidth, // Responsive divider thickness
            textColor:Color(0xff0e1712),
            cardColor: Colors.white,
            companyColor: Colors.white,
            taglineColor: Colors.white,
            emailText: 'mahmoudrabeea992@gmail.com',
            websiteText: 'صفحة ابو ربيع للمشويات',
            facebookHandle: "AboRabi3Restaurant",
          ),
        ),
      ),
    );
  }
}
