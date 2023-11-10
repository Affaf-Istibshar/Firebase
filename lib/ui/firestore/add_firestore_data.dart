import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finallyfirebase/ui/firestore/firestore_list_screen.dart';
import 'package:finallyfirebase/utils/utils.dart';
import 'package:finallyfirebase/widgets/roundbutton.dart';
import 'package:flutter/material.dart';

class AddFirestorePosts extends StatefulWidget {
  const AddFirestorePosts({super.key});

  @override
  State<AddFirestorePosts> createState() => _AddFirestorePostsState();
}

class _AddFirestorePostsState extends State<AddFirestorePosts> {
  final postController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Firestore data'),
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
                  title: 'Add Firestore Post to your Firestore database',
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> FirestoreScreen()));
                    setState(() {
                      loading = true;
                    });
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    fireStore.doc(id).set({
                      'title': postController.text.toString(),
                      'id': id,
                    }).then((value) {
                      Utils().toastMessage('Post Added');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  })
            ],
          ),
        ));
  }
}
