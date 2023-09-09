import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rabe3/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FullMenu extends StatefulWidget {
  const FullMenu({Key? key}) : super(key: key);

  @override
  State<FullMenu> createState() => _FullMenuState();
}

class _FullMenuState extends State<FullMenu> {
  List CategoriesList = [];

  @override
  void initState() {
    super.initState();
    getData2();
    getData();
  }

  void getData2() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isAdmin = prefs.getBool("isAdmin") ?? false;

    FirebaseFirestore.instance
        .collection('categories')
        .snapshots()
        .listen((event) {
      for (var element in event.docs) {
        var mydata = element.data();
        List AllcategoriesList = mydata['categories'] ?? [];

        if (AllcategoriesList.isNotEmpty) {
          setState(() {
            CategoriesList.addAll(AllcategoriesList);
          });
        }
      }
    });
  }

  bool isAdmin = false;
  List<Map<String, dynamic>> oldCardList = [];
  List allTitle = [];

  void getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? oldEncodedMap = await prefs.getString("favorite");
    allTitle.clear();
    if (oldEncodedMap != null) {
      oldCardList = List<Map<String, dynamic>>.from(json.decode(oldEncodedMap));
    }

    for (var i = 0; i < oldCardList.length; i++) {
      allTitle.add(oldCardList[i]['title']);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    getData();
    setState(() {});
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff0e1712),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "منيو  أبو  ربيع",
            style: GoogleFonts.cairo(
              textStyle: TextStyle(
                color: Color(0xff0e1712),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            for (var i = 0; i < CategoriesList.length; i++)
              Stack(children: [
                CustomCard(
                  imagePath: '${CategoriesList[i]['img']}',
                  title: CategoriesList[i]['name'],
                  price: "${CategoriesList[i]['price']} ج",
                  isFavorite: allTitle.contains(CategoriesList[i]['name'])
                      ? true
                      : false,
                  description: CategoriesList[i]['subTitle'],
                  onTapFavorite: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? oldEncodedMap = prefs.getString("favorite");
                    List<Map<String, dynamic>> oldCardList = [];
                    if (oldEncodedMap != null) {
                      oldCardList = List<Map<String, dynamic>>.from(
                          json.decode(oldEncodedMap));
                    }

                    if (oldCardList.isEmpty) {
                      Map<String, dynamic> newCard = {
                        "title": CategoriesList[i]['name'],
                        "price":  int.parse(CategoriesList[i]['price']).toDouble(),
                        "description": '',
                        "image": CategoriesList[i]['img'],
                        'quantity': 1
                      };

                      oldCardList.add(newCard);
                      String encodedMap = json.encode(oldCardList);
                      await prefs.setString("favorite", encodedMap);
                      setState(() {});
                      print('done addd');
                    } else if (allTitle.contains(CategoriesList[i]['name']) ==
                        true) {
                      for (var ii = 0; ii < oldCardList.length; ii++) {
                        allTitle.remove(oldCardList[ii]);
                        oldCardList.remove(oldCardList[ii]);
                      }
                      String encodedMap = json.encode(oldCardList);
                      await prefs.setString("favorite", encodedMap);
                      print("done Remove");
                      getData();

                      setState(() {});
                    } else {
                      print('start add....');

                      Map<String, dynamic> newCard = {
                        "title": CategoriesList[i]['name'],
                        "price":  int.parse(CategoriesList[i]['price']).toDouble(),
                        "description": '',
                        "image": CategoriesList[i]['img'],
                        'quantity': 1
                      };

                      oldCardList.add(newCard);
                      String encodedMap = json.encode(oldCardList);
                      await prefs.setString("favorite", encodedMap);
                      setState(() {});
                      print('done addd');
                    }
                    setState(() {});
                  },
                  onTapShopping: () {
                    cartList.add(CartListModel(
                        title: CategoriesList[i]['name'],
                        price: int.parse(CategoriesList[i]['price']).toDouble(),
                        description: '',
                        image: CategoriesList[i]['img'],
                        quantity: 1));
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        Timer(Duration(milliseconds: 500), () {
                          Navigator.pop(context);
                        });
                        return AlertDialog(
                          title: Text("Done Add"),
                        );
                      },
                    );
                  },
                ),
              ])
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String price;
  final String description;
  final Function() onTapShopping;
  final Function() onTapFavorite;
  bool isFavorite;

  CustomCard({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.description,
    required this.onTapFavorite,
    required this.onTapShopping,
    this.isFavorite = false,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(color: Color(0xff0e1712), width: 3.0),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  widget.imagePath,
                  width: screenWidth,
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.price,
                      style: GoogleFonts.reemKufiInk(
                        textStyle: TextStyle(
                          fontSize: 0.07 * screenWidth, // Responsive font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 0.04 * screenWidth, // Responsive spacing
                    ),
                    Text(
                      widget.title,
                      style: GoogleFonts.reemKufiInk(
                        textStyle: TextStyle(
                          fontSize: 0.07 * screenWidth, // Responsive font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.description,
                  
                  style: GoogleFonts.reemKufiInk(
                    textStyle: TextStyle(
                      fontSize: 0.06 * screenWidth, // Responsive font size
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 0.02 * screenWidth, // Responsive spacing
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 0.05 * screenWidth, // Responsive padding
                    left: 0.15 * screenWidth, // Responsive padding
                  ),
                  child: IconButton(
                    onPressed: () => widget.onTapShopping(),
                    icon: Icon(
                      Icons.shopping_cart_rounded,
                      size: 0.1 * screenWidth, // Responsive icon size
                      color: Color(0xff0e1712),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 0.05 * screenWidth, // Responsive padding
                    right: 0.15 * screenWidth, // Responsive padding
                  ),
                  child: IconButton(
                    icon: Icon(
                      widget.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 0.1 * screenWidth, // Responsive icon size
                      color: Color(0xff0e1712),
                    ),
                    onPressed: () {
                      widget.onTapFavorite();
                      setState(() {
                        widget.isFavorite = !widget.isFavorite;
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
