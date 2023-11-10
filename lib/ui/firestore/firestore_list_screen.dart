import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finallyfirebase/ui/auth/loginscreen.dart';
import 'package:finallyfirebase/ui/firestore/add_firestore_data.dart';
import 'package:finallyfirebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final auth = FirebaseAuth.instance;
  final editFilter = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Firestore'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddFirestorePosts()));
          // Navigator.push(context,
          //        MaterialPageRoute(builder: (context) => const AddPosts()));
          //
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return  CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return  Text('Some Error');
                }
                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  snapshot.data!.docs[index]['title'].toString()),
                              subtitle: Text(
                                snapshot.data!.docs[index]['id'].toString(),
                              ),
                              onTap: (){
                                //for updating posts
                                ref.doc(snapshot.data!.docs[index]['id'].toString()).update({
                                  'title' : 'Affaf'
                                }).then((value){
                                  Utils().toastMessage('Updated');
                                }).onError((error, stackTrace) {
                                  Utils().toastMessage(error.toString());
                                });
                                //for deleting posts
                                ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                              },

                            );
                          }));
                }
              ),
        ],
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editFilter.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              controller: editFilter,
              decoration: const InputDecoration(hintText: 'edit'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Update'),
              ),
            ],
          );
        });
  }
}
