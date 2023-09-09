import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:rabe3/view/Screens/FavouritePage/FavouritePage.dart';
import 'package:rabe3/view/Screens/Homescreen/MainSCreen.dart';
import 'package:rabe3/view/Screens/cartpage/cartpage.dart';
import 'package:rabe3/view/Screens/contact%20us/Contact.dart';
import 'package:rabe3/view/menu/fullmenu.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isConnected = true; // Assume initially connected

  @override
  void initState() {
    super.initState();
    _checkConnectivity(); // Check the initial connectivity
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _handleConnectivityChange(result);
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
      });
    }
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    setState(() {
      _isConnected = (result != ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isConnected
          ? LayoutBuilder(
        builder: (context, constraints) {
          return PersistentTabView(
            context,
            screens: Screens(context),
            items: navBarItems(),
            //navBarStyle: NavBarStyle.style14,
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(), // Circular progress indicator
      ),
    );
  }
}

// ... Other methods



List<Widget> Screens(context){
  return  [
    FirstScreen(context :context),
    FullMenu(),
    CartPage(),
    FavouritePage(),
    Contactus(context:context),
  ];
}
List<PersistentBottomNavBarItem> navBarItems(){
  return [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home) ,
      title: "الاصناف",
      activeColorPrimary: Color(0xff0e1712),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.restaurant_menu)  ,
      title: "المنيو كامل",
      activeColorPrimary: Color(0xff0e1712),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.shopping_cart)  ,
      title: "طلباتك",
      activeColorPrimary: Color(0xff0e1712),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.favorite)  ,
      title: "المفضلة",
      activeColorPrimary: Color(0xff0e1712),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.contacts)  ,
      title: "تواصل معنا",
      activeColorPrimary: Color(0xff0e1712),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
  ];
}
