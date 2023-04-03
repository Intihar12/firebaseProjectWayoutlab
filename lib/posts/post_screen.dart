import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasrproject/posts/add_posts.dart';
import 'package:firebasrproject/ui/auth/login_screen.dart';
import 'package:firebasrproject/utils/utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final firebaseRef = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final updateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Post"),
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
            TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(border: OutlineInputBorder(), hintText: "search"),
              onChanged: (String value) {
                setState(() {});
              },
            ),
            Expanded(
              child: FirebaseAnimatedList(
                  query: firebaseRef,
                  itemBuilder: (context, snapShot, animation, index) {
                    final title = snapShot.child('title').value.toString();
                    final id = snapShot.child('id').value.toString();
                    if (searchFilter.text.isEmpty) {
                      return ListTile(
                        title: Text(title),
                        subtitle: Text(snapShot.child('id').value.toString()),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showMYdiplog(title, snapShot.child('id').value.toString());
                              },
                              title: Text("Edit"),
                              leading: Icon(Icons.edit),
                            )),
                            PopupMenuItem(
                                child: ListTile(
                              title: Text("Delete"),
                              leading: Icon(Icons.delete),
                            ))
                          ],
                        ),
                      );
                    } else if (title.toLowerCase().contains(searchFilter.text.toLowerCase().toLowerCase())) {
                      return ListTile(
                        title: Text(snapShot.child('title').value.toString()),
                        subtitle: Text(snapShot.child('id').value.toString()),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: ListTile(
                              title: Text("Edit"),
                              leading: Icon(Icons.edit),
                            )),
                            PopupMenuItem(
                                child: ListTile(
                              onTap: () {
                                firebaseRef.child(snapShot.child('id').value.toString()).remove();
                              },
                              title: Text("Delete"),
                              leading: Icon(Icons.delete),
                            ))
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            )
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
                    firebaseRef.child(id).update({"title": updateController.text}).then((value) => {Utils().toastMessage("updated")}).onError((error, stackTrace) => {Utils().toastMessage(error.toString())});
                    Navigator.pop(context);
                  },
                  child: Text("update"))
            ],
          );
        });
  }
  // Expanded(
  // child: StreamBuilder(
  // stream: firebaseRef.onValue,
  // builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
  // if (!snapshot.hasData) {
  // return Text("Loading");
  // } else {
  // Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
  // // snapshot.data!.snapshot.value[index]['title'];
  // List<dynamic> list = [];
  // list.clear();
  // list = map.values.toList();
  // return ListView.builder(
  // itemCount: snapshot.data?.snapshot.children.length,
  // itemBuilder: (BuildContext context, int index) {
  // return ListTile(
  // title: Text(list[index]['title']),
  // );
  // });
  // }
  // },
  // )),
}
