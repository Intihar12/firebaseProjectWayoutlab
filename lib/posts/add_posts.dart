import 'package:firebase_database/firebase_database.dart';
import 'package:firebasrproject/utils/utils.dart';
import 'package:firebasrproject/widgets/round_botton_widget.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final addPostController = TextEditingController();
  final firebaseRef = FirebaseDatabase.instance.ref("Post");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add post"),
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
                firebaseRef.child(DateTime.now().microsecondsSinceEpoch.toString()).set({
                  "id": "1",
                  "title": addPostController.text,
                }).then((value) {
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
