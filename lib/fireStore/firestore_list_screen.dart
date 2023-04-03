import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasrproject/fireStore/add_fire_store_data.dart';
import 'package:firebasrproject/posts/add_posts.dart';
import 'package:firebasrproject/ui/auth/login_screen.dart';
import 'package:firebasrproject/utils/utils.dart';
import 'package:flutter/material.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key}) : super(key: key);

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;
  final searchFilter = TextEditingController();
  final updateController = TextEditingController();
  final usersCollections = FirebaseFirestore.instance.collection('Users').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddFireStoreDataScreen()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("fire store"),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: usersCollections,
                builder: (BuildContext cont, AsyncSnapshot<QuerySnapshot> snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapShot.hasError) {
                    return Text("some thing went wrong");
                  }
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapShot.data?.docs.length,
                        itemBuilder: (BuildContext contex, int index) {
                          return ListTile(
                            title: Text(snapShot.data!.docs[index]['title'].toString()),
                          );
                        }),
                  );
                })
          ],
        ),
      ),
    );
  }

  Future<void> showMYdiplog(String title, String id) async {
    updateController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextFormField(
                controller: updateController,
                decoration: InputDecoration(hintText: "Update"),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("update"))
            ],
          );
        });
  }
}
