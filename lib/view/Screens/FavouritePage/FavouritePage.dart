import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rabe3/view/menu/fullmenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<Map<String, dynamic>> favoriteList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? oldEncodedMap = prefs.getString("favorite");

    setState(() {
      favoriteList = List<Map<String, dynamic>>.from(json.decode(oldEncodedMap!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              child: ListView.builder(
                itemCount: favoriteList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.05,
                      vertical: constraints.maxHeight * 0.02,
                    ),
                    child: CustomCard(
                      isFavorite: true,
                      imagePath: favoriteList[index]['image'],
                      title: favoriteList[index]['title'],
                      price: "${favoriteList[index]['price']}",
                      description: '',
                      onTapFavorite: () async {
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        favoriteList.removeAt(index);
                        String encodedMap = json.encode(favoriteList);
                        prefs.setString("favorite", encodedMap);
                        setState(() {});
                      },
                      onTapShopping: () {},
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
