import 'package:finallyfirebase/ui/auth/loginscreen.dart';
import 'package:finallyfirebase/ui/posts/add_posts.dart';
import 'package:finallyfirebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editFilter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Posts'),
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPosts()));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                hintText: 'search',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Text('loading'),
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  if (searchFilter.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialog(title,
                                    snapshot.child('id').value.toString());
                              },
                              leading: const Icon(Icons.edit),
                              title: const Text('Edit'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                ref
                                    .child(
                                        snapshot.child('id').value.toString())
                                    .remove();
                              },
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (title
                      .toLowerCase()
                      .toLowerCase()
                      .contains(searchFilter.text.toString())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                }),
          )
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
                onPressed: () {
                  Navigator.pop(context);
                  ref.child(id).update(
                      {'title': editFilter.text.toLowerCase()}).then((value) {
                    Utils().toastMessage('post Updated');
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }
}
// Getting data from firebase using stream builder
// //stream builder ma list return hoti ha
// Expanded(child: StreamBuilder(
// stream: ref.onValue,
// builder: (context ,AsyncSnapshot<DatabaseEvent> snapshot){
// if(!snapshot.hasData) {
// return const CircularProgressIndicator();
// }
// else {
// Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = [];
// list.clear();
// list = map.values.toList();
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context , index){
// return  ListTile(
// title: Text(list[index]['id'].toString()),
// subtitle: Text(list[index]['id'].toString()),
// );
// });
// }},
// )),
