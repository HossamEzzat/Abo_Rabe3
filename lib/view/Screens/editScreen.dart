import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key, this.isData}) : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>>? isData;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final NameController = TextEditingController();
  final subTitleController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    if (widget.isData != null) {
      NameController.text = widget.isData!['name'];
      subTitleController.text = widget.isData!['subTitle'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xff0e1712),
      appBar: AppBar(
        backgroundColor: Color(0xff0e1712),
        actions: [
          if (screenWidth > 600) SizedBox(width: 10),
          IconButton(
            onPressed: () => _pickImage(),
            icon: Icon(Icons.camera_alt_rounded),
          ),
          if (widget.isData != null)
            IconButton(
              onPressed: (){
                FirebaseFirestore.instance
                    .collection("categories")
                    .doc(widget.isData!.id)
                    .delete();
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete),
            ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                _buildImageSection(),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  controller: NameController,
                  hintText: "Name",
                ),
                SizedBox(height: screenHeight * 0.01),
                _buildTextField(
                  controller: subTitleController,
                  hintText: "SubTitle",
                ),
                SizedBox(height: screenHeight * 0.06),
                ElevatedButton(
                  onPressed: () async {
                    await _handleUpdateButton();
                  },
                  child: Text("Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.red,
          height: 150,
          child: doneSelected
              ? Image.file(img!)
              : widget.isData != null
              ? Image.network(
            widget.isData!['img'],
            height: 150,
            fit: BoxFit.fill,
          )
              : Container(),
        ),
        doneSelected
            ? SizedBox.shrink()
            : Icon(
          Icons.image,
          size: 80,
          color: Colors.white.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Color.fromARGB(120, 231, 231, 231),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Can't be empty";
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }

  Future<void> _handleUpdateButton() async {
    if (formKey.currentState!.validate()) {
      if (img != null && widget.isData == null) {
        String imageUrl = await _uploadImages(img!);

        await FirebaseFirestore.instance.collection("categories").add({
          "img": imageUrl,
          "name": NameController.text,
          "subTitle": subTitleController.text,
          "categories": [],
        });

        Navigator.pop(context);
      }

      if (widget.isData != null) {
        if (img != null) {
          String imageUrl = await _uploadImages(img!);
          await FirebaseFirestore.instance
              .collection("categories")
              .doc(widget.isData!.id)
              .update({
            "img": imageUrl,
            "name": NameController.text,
            "subTitle": subTitleController.text,
            "categories": [],
          });
        } else {
          await FirebaseFirestore.instance
              .collection("categories")
              .doc(widget.isData!.id)
              .update({
            "name": NameController.text,
            "subTitle": subTitleController.text,
            "categories": [],
          });
        }

        Navigator.pop(context);
      }
    }
  }

  Future<String> _uploadImages(File image) async {
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('Category/${DateTime.now().millisecondsSinceEpoch}.jpg');

    final UploadTask uploadTask = storageReference.putFile(image);
    final TaskSnapshot downloadUrl = await uploadTask.whenComplete(() {});

    final String url = await downloadUrl.ref.getDownloadURL();

    return url;
  }
}
