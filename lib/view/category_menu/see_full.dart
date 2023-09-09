import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rabe3/main.dart';
import 'package:rabe3/view/menu/fullmenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeeCategory extends StatefulWidget {
  const SeeCategory({Key? key, required this.isData, required this.isAdmin})
      : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> isData;
  final bool isAdmin;
  @override
  State<SeeCategory> createState() => _SeeCategoryState();
}

class _SeeCategoryState extends State<SeeCategory> {
  final NameController = TextEditingController();
  final subTitleController = TextEditingController();
  final priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? img;
  bool doneSelected = false;
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        doneSelected = true;
        img = File(pickedFile.path);
      });
    }
  }
List<Map<String, dynamic>> oldCardList = [];
  List allTitle = [];

void getData() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
String? oldEncodedMap =await prefs.getString("favorite");
allTitle.clear();
if (oldEncodedMap != null) {
  oldCardList = List<Map<String, dynamic>>.from(json.decode(oldEncodedMap));
}

for (var i = 0; i < oldCardList.length; i++) {
  allTitle.add(oldCardList[i]['title']);
  // print('object');
  // print(allTitle);
}
setState(() {});
}

  Future<String> _uploadImages(File image) async {
    // يتم إنشاء مرجع لملف الصورة في Firebase Storage
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('Category/${DateTime.now().millisecondsSinceEpoch}.jpg');

    // يتم رفع الملف إلى Firebase Storage ويتم انتظار الاستجابة
    final UploadTask uploadTask = storageReference.putFile(image);
    final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() {}));

    // يتم جلب رابط التنزيل للملف المرفوع
    final String url = (await downloadUrl.ref.getDownloadURL());

    // يتم إضافة رابط التنزيل للصورة المرفوعة إلى قائمة الروابط

    return url;
  }

  @override
  Widget build(BuildContext context) {
getData();
// for (var i = 0; i < widget.isData['categories']; i++) {
//    if (allTitle.contains(widget.isData['categories'][i]['name']) == true) {
// for (var ii = 0; ii < oldCardList.length; ii++) ;
//  }
// }


setState(() {});

    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xff0e1712),
          appBar: AppBar(
            backgroundColor: Colors.grey,
            title: Text(
              "${widget.isData['name']}",
              style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                color: Color(0xff0e1712),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
            ),
            centerTitle: true,
            actions: [
              if (widget.isAdmin == true)
                IconButton(onPressed: () => addNew(), icon: Icon(Icons.add))
            ],
          ),
          body: widget.isData['categories'].isNotEmpty &&
                  widget.isData['categories'] != null
              ? ListView(
                  children: [
                    for (var index = 0; index < widget.isData['categories'].length; index++)
                      Stack(
                        children: [
                          CustomCard(
                            imagePath:
                                '${widget.isData['categories'][index]['img']}', // Replace with your meal image
                            title: widget.isData['categories'][index]['name'],
                            price: "${widget.isData['categories'][index]['price']}ج",
                            description: '${widget.isData['categories'][index]['subTitle']}',
                            isFavorite: allTitle.contains( widget.isData['categories'][index]['name']) ? true : false ,
                            onTapFavorite: ()async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
    
                        var sa = int.parse(widget.isData['categories'][index]['price']);
     

if(oldCardList.isEmpty) {
  
  Map<String, dynamic> newCard = {
  "title": widget.isData['categories'][index]['name'],
  "price": "${sa.toDouble()}",
  "description": widget.isData['categories'][index]['subTitle'],
  "image": widget.isData['categories'][index]['img'],
  'quantity': 1
};

oldCardList.add(newCard);
String encodedMap = json.encode(oldCardList);
await prefs.setString("favorite", encodedMap);
setState(() {});
print('done addd');
}

else  if (allTitle.contains(widget.isData['categories'][index]['name']) == true) {
for (var ii = 0; ii < oldCardList.length; ii++) {
  allTitle.remove(oldCardList[ii]);
  oldCardList.remove(oldCardList[ii]);
}
String encodedMap = json.encode(oldCardList);
await prefs.setString("favorite", encodedMap);
print("done Remove");

getData();
setState(() {
  
});
}else{
print('start add....');

  Map<String, dynamic> newCard = {
  "title": widget.isData['categories'][index]['name'],
  "price": "${sa.toDouble()}",
  "description": '',
  "image": widget.isData['categories'][index]['img'],
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
                        var sa = int.parse(widget.isData['categories'][index]['price']);
 cartList.add(CartListModel(
                                  title: widget.isData['categories'][index]['name'],
                                  price: sa.toDouble(),
                                  description: '',
                                  image: widget.isData['categories'][index]['img'], quantity: 1));
                        showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        Timer(Duration(milliseconds: 500), () {Navigator.pop(context); });
        return AlertDialog(
          title:  Text("Done Add"),

        );
      },
    );   
                                
                                  

                                  // print(cartList.length);
                            },
                          ),
                          widget.isAdmin == true
                              ? Positioned(
                                  top: 30,
                                  left: 25,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .collection('categories')
                                          .doc(widget.isData.id)
                                          .update({
                                        "categories": FieldValue.arrayRemove(
                                            [widget.isData['categories'][index]])
                                      });
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        )),
                                  ))
                              : Container()
                        ],
                      )
                  ],
                )
              : Center(
                  child: Text("Empty"),
                )),
    );
  }

  void addNew() async {
    _pickImage().then((value) {
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      Image.file(
                        img!,
                        height: 100,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(120, 231, 231, 231),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "cant Empty";
                            }
                            return null;
                          },
                          controller: NameController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Name"),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(120, 231, 231, 231),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "cant Empty";
                            }
                            return null;
                          },
                          controller: subTitleController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "SubTitle"),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(120, 231, 231, 231),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "cant Empty";
                            }
                            return null;
                          },
                          controller: priceController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Price"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      String imageUrl = await _uploadImages(img!);

                      FirebaseFirestore.instance
                          .collection("categories")
                          .doc(widget.isData.id)
                          .update({
                        "categories": FieldValue.arrayUnion([
                          {
                            "img": imageUrl,
                            "name": NameController.text,
                            "subTitle": subTitleController.text,
                            "price": priceController.text
                          }
                        ])
                      });
                      img = null;
                      NameController.clear();
                      subTitleController.clear();
                      priceController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Update"))
            ],
          );
        },
      );
    });
  }
}


/*

 CustomCard(
              imagePath: 'assets/sandwich2.jpg', // Replace with your meal image
              title: 'سندوتش كباب', price: ' ج 60', description: '',
            ),
            CustomCard(
              imagePath: 'assets/koftaaaa.jpg', // Replace with your meal image
              title: 'سندوتش كفته', price: ' ج 35-45-50', description: '',
            ),
            CustomCard(
              imagePath: 'assets/tarp.png', // Replace with your meal image
              title: 'سندوتش طرب', price: ' ج 55', description: '',
            ),
            CustomCard(
              imagePath: 'assets/kapdamashwai.jpg', // Replace with your meal image
              title: 'سندوتش كبدة ضاني', price: ' ج 55', description: '',
            ),
            CustomCard(
              imagePath: 'assets/sheshtiiq.jpg', // Replace with your meal image
              title: 'سندوتش شيش طاووق', price: ' ج 40', description: '',
            ),
            CustomCard(
              imagePath: 'assets/hwawshiwarsha.jpg', // Replace with your meal image
              title: 'سندوتش حوواوشي ورش', price: ' ج 60', description: '',
            ),
            CustomCard(
              imagePath: 'assets/hwawshidani.jpg', // Replace with your meal image
              title: 'سندوتش حوواوشي ضاني', price: ' ج 50', description: '',
            ),
            CustomCard(
              imagePath: 'assets/hwawshimotza.jpg', // Replace with your meal image
              title: 'سندوتش حوواوشي موتزاريلا', price: ' ج 55', description: '',
            ),


 */