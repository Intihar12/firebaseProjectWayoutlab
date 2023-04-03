import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasrproject/utils/utils.dart';
import 'package:firebasrproject/widgets/round_botton_widget.dart';
import 'package:flutter/material.dart';

class AddFireStoreDataScreen extends StatefulWidget {
  const AddFireStoreDataScreen({Key? key}) : super(key: key);

  @override
  State<AddFireStoreDataScreen> createState() => _AddFireStoreDataScreenState();
}

class _AddFireStoreDataScreenState extends State<AddFireStoreDataScreen> {
  bool loading = false;
  final addPostController = TextEditingController();
  final userCollection = FirebaseFirestore.instance.collection("Users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add fireStore"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: addPostController,
              maxLines: 4,
              decoration: InputDecoration(border: OutlineInputBorder(), helperText: "your text is here"),
            ),
            SizedBox(
              height: 50,
            ),
            RoundButtonWidget(
              title: "post",
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                // String id = DateTime.now().microsecondsSinceEpoch.toString();
                DocumentReference doc = userCollection.doc();
                Map<String, dynamic> data = {
                  "id": doc.id,
                  "title": addPostController.text,
                };
                doc.set(data).then((value) {
                  Utils().toastMessage("post Added");
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
