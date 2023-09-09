import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:rabe3/view/Screens/onbordingscreen/onboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/Screens/Homescreen/HomeScreen.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
  final bool onBoarding = prefs.getBool('onBoarding') ?? false;

  runApp( MyApp(isUserLoggedIn:isUserLoggedIn,onBoarding:onBoarding));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,required this.isUserLoggedIn,required this.onBoarding});
final bool isUserLoggedIn;
final bool onBoarding;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DateTime? lastBackPressedTime;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        duration: 1000,
        splash: Image.asset("assets/lanch.jpg",fit: BoxFit.cover,),
        nextScreen:onBoarding ? WillPopScope(
            onWillPop: () async {
              final currentTime = DateTime.now();
              final backButtonPressed = lastBackPressedTime == null ||
                  currentTime.difference(lastBackPressedTime!) > Duration(seconds: 2);

              if (backButtonPressed) {
                lastBackPressedTime = currentTime;
                return false; // Don't exit, wait for the second press
              } else {
                return true; // Exit the app
              }
            },
            child: HomeScreen(),
        )  : OnboardingScreen(),
        backgroundColor: Colors.black,
        splashIconSize: double.infinity,
        splashTransition: SplashTransition.sizeTransition,

      ),
    );
  }
}


 List<CartListModel> cartList = [];

class CartListModel {
   String title;
   double price;
   String image;
  int quantity;
 String description;
CartListModel({required this.title,required this.price,required this.description,required this.image, required this.quantity});
Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  factory CartListModel.fromMap(Map<String, dynamic> map) {
    return CartListModel(
      title: map['title'],
      price: map['price'],
      image: map['image'],
      quantity: map['quantity'],
      description: '',
    );
  }

}


