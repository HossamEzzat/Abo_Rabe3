import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rabe3/view/Screens/editScreen.dart';
import 'package:rabe3/view/category_menu/see_full.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key, required this.context}) : super(key: key);
  final BuildContext context;

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<String> imgList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection("carousel")
        .snapshots()
        .listen((event) {
      imgList.clear();
      event.docs.forEach((doc) {
        setState(() {
          var imgData = doc.data()['img'];
          if (imgData is Iterable<String>) {
            imgList.addAll(imgData);
          } else if (imgData is String) {
            imgList.add(imgData);
          }
        });
      });
    });
    isAdmin = prefs.getBool("isAdmin") ?? false;
  }

  bool isAdmin = false;

  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final List<Widget> imageSliders = imgList
        .map(
          (item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12.0,
                    ),
                  ],
                ),
                child: isAdmin == true
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: Image.network(
                              item,
                              fit: BoxFit.cover,
                              width: 1000.0,
                            ),
                          ),
                          Positioned(
                            left: 3,
                            top: 3,
                            child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black),
                                child: IconButton(
                                    onPressed: () async {
                                      FirebaseFirestore.instance
                                          .collection('carousel')
                                          .where("img", isEqualTo: item)
                                          .get()
                                          .then((value) async {
                                        for (var i = 0;
                                            i < value.docs.length;
                                            i++) {
                                          await FirebaseFirestore.instance
                                              .collection("carousel")
                                              .doc(value.docs[i].id)
                                              .delete();
                                          getData();
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ))),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: Image.network(
                          item,
                          fit: BoxFit.cover,
                          width: 1000.0,
                        ),
                      ),
              ),
            ),
          ),
        )
        .toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff0e1712),
        body: Column(
          children: [
            if (isAdmin)
              IconButton(
                onPressed: () {
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

                  Future<String> _uploadImages(File image) async {
                    final Reference storageReference = FirebaseStorage.instance
                        .ref()
                        .child(
                            'carousel/${DateTime.now().millisecondsSinceEpoch}.jpg');

                    final UploadTask uploadTask =
                        storageReference.putFile(image);
                    final TaskSnapshot downloadUrl =
                        (await uploadTask.whenComplete(() {}));

                    final String url = (await downloadUrl.ref.getDownloadURL());

                    return url;
                  }

                  _pickImage().then((value) {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      context: widget.context,
                      builder: (context) {
                        return Column(
                          children: [
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            img != null
                                ? Image.file(
                                    img!,
                                    height: 100,
                                  )
                                : Container(
                                    color: Colors.red,
                                    height: 150,
                                  ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                String imageUrl = await _uploadImages(img!);

                                FirebaseFirestore.instance
                                    .collection("carousel")
                                    .add({
                                  "img": imageUrl,
                                });
                                getData();
                                Navigator.pop(context);
                              },
                              child: Text("Upload"),
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
                icon: Icon(Icons.add),
              ),
            Container(
              padding: EdgeInsets.only(top: 22),
              child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                items: imageSliders,
              ),
            ),
            Divider(
              thickness: 2,
              color: Color(0xfff7e4a1),
            ),
            isAdmin
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditScreen(),
                        ),
                      );
                    },
                    child: Icon(Icons.add),
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("categories")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final isData = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () => onTap(isData: isData),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 15, left: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color(0xff0e1712), width: 2.0),
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  isAdmin
                                      ? Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditScreen(
                                                          isData: isData),
                                                ),
                                              );
                                            },
                                            child: Icon(Icons.edit),
                                          ),
                                        )
                                      : Container(),
                                  Column(
                                    children: [
                                      Text(
                                        '${isData['name']}',
                                        style: GoogleFonts.reemKufiInk(
                                          textStyle: TextStyle(
                                            color: Color(0xff0e1712),
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${isData['subTitle']}',
                                        style: GoogleFonts.reemKufiInk(
                                          textStyle: TextStyle(
                                            color: Color(0xff0e1712),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              NetworkImage('${isData['img']}'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTap({required QueryDocumentSnapshot<Map<String, dynamic>> isData}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeeCategory(isData: isData, isAdmin: isAdmin),
      ),
    );
  }
}
