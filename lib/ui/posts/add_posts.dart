import 'package:finallyfirebase/utils/utils.dart';
import 'package:finallyfirebase/widgets/roundbutton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPosts extends StatefulWidget {
  const AddPosts({super.key});

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  final postController = TextEditingController();
  bool loading = false;
  //this line creates a table in firebase for us
  //created a instance of firebase database, on firebase words
  // we have created a node "POST" ,,,
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new posts'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: postController,
                decoration: const InputDecoration(
                  hintText: 'Whats in your mind?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                loading: loading,
                title: 'Add',
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  // "set" add data for us
                  //insert operation query
                  //taking reference of POST and setting
                  // data to db
                  //millisecond as time changes always
                  databaseRef
                      .child(id)
                      .set({
                    'title': postController.text.toString(),
                    'id': id
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                },
              )
            ],
          ),
        ));
  }
}
