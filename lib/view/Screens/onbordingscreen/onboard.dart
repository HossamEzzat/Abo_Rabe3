import 'package:flutter/material.dart';
import 'package:rabe3/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rabe3/view/Screens/Login/SignIn.dart';

import '../Homescreen/HomeScreen.dart';
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffaf9f6),

      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xfffaf9f6),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) =>  HomeScreen()));
              }, //to login screen. We will update later
              child:  Text(
                  'تخطي',
                  style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                      color:Color(0xff0e1712),
                      fontSize: 19.0,
                      fontWeight: FontWeight.w400,
                    ),
                  )
              ),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: [
              createPage(
                image: 'assets/mshwi.png',

                title: Constants.titleTwo,
                description: Constants.descriptionTwo,
              ),
              createPage(
                image: 'assets/tajjn.jpg',
                title: Constants.titleFour,
                description: Constants.descriptionFour,
              ),
              createPage(
                image: 'assets/swani_elmandi.jpg',
                title: Constants.titleOne,
                description: Constants.descriptionOne,
              ),

              createPage(
                image: 'assets/rrsh.jpg',
                title: Constants.titleThree,
                description: Constants.descriptionThree,
              ),

              createPage(
                image: 'assets/swani.jpg',
                title: Constants.titleFive,
                description: Constants.descriptionFive,
              ),
              createPage(
                image: 'assets/makrona.jpg',
                title: Constants.titleSix,
                description: Constants.descriptionSix,
              ),
              createPage(
                image: 'assets/h.jpg',
                title: Constants.titleSev,
                description: Constants.descriptionSev,
              ),
              createPage(
                image: 'assets/shourba.jpg',
                title: Constants.title8,
                description: Constants.description8,
              ),
              createPage(
                image: 'assets/aser.jpg',
                title: Constants.Jtitle9,
                description: Constants.JDescription9,
              ),

            ],
          ),
          Positioned(
            bottom: 80,
            left: 30,
            child: Row(
              children: _buildIndicator(),
            ),
          ),
          Positioned(
            bottom: 60,
            right: 30,
            child: Container(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (currentIndex < 8) {
                        currentIndex++;
                        if (currentIndex < 9) {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        }
                      } else {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) =>  HomeScreen()));
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                    color: Colors.white,
                  )),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff9b0d0c),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Extra Widgets

  //Create the indicator decorations widget
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10.0,
      width: isActive ? 20 : 8,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: Color(0xff9b0d0c),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

//Create the indicator list
  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];

    for (int i = 0; i < 6; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}

class createPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const createPage({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 380,
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 25.0,
                  ),
                ],),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(image,fit: BoxFit.fill,)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style:GoogleFonts.reemKufiInk(
                textStyle: TextStyle(
                  color: Color(0xff9b0d0c),
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.reemKufi(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff0e1712),

                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}