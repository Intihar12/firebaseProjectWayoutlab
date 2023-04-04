import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasrproject/main.dart';
import 'package:firebasrproject/utils/utils.dart';
import 'package:firebasrproject/widgets/round_botton_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImagesScreens extends StatefulWidget {
  const UploadImagesScreens({Key? key}) : super(key: key);

  @override
  State<UploadImagesScreens> createState() => _UploadImagesScreensState();
}

class _UploadImagesScreensState extends State<UploadImagesScreens> {
  File? image;
  bool loading = false;
  bool isLoading = false;
  final imagePicker = ImagePicker();
  firebase_storage.FirebaseStorage firebaseStorage = firebase_storage.FirebaseStorage.instance;
  DatabaseReference firebaseRef = FirebaseDatabase.instance.ref("Post");
  final userCollection = FirebaseFirestore.instance.collection("Users");

  Future getGalleryImage() async {
    final pickedImg = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImg != null) {
        image = File(pickedImg.path);
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload images"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                getGalleryImage();
              },
              child: Center(
                child: Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: image != null ? Image.file(image!.absolute) : Icon(Icons.image),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RoundButtonWidget(
                title: "upload",
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref("/imageFolder" + DateTime.now().microsecondsSinceEpoch.toString());
                  firebase_storage.UploadTask uploadTask = ref.putFile(image!.absolute);
                  Future.value(uploadTask).then((value) {
                    var imgUrl = ref.getDownloadURL();
                    firebaseRef.child("1").set({"title": imgUrl.toString(), "id": DateTime.now().microsecondsSinceEpoch.toString()}).then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage("uploaded");
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(error.toString());
                    });
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                }),
            SizedBox(
              height: 10,
            ),
            RoundButtonWidget(
                title: "upload",
                loading: isLoading,
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  DocumentReference doc = userCollection.doc();
                  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref("/imageFolder" + doc.id);
                  firebase_storage.UploadTask uploadTask = ref.putFile(image!.absolute);
                  Future.value(uploadTask).then((value) async {
                    String imgUrl = await ref.getDownloadURL();
                    print("img url is " + imgUrl);
                    userCollection.doc(doc.id).set({"title": imgUrl.toString(), "id": doc.id}).then((value) {
                      setState(() {
                        isLoading = false;
                      });
                      Utils().toastMessage("uploaded");
                    }).onError((error, stackTrace) {
                      setState(() {
                        isLoading = false;
                      });
                      Utils().toastMessage(error.toString());
                    });
                  }).onError((error, stackTrace) {
                    setState(() {
                      isLoading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
