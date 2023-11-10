import 'package:finallyfirebase/ui/posts/postsScreen.dart';
import 'package:finallyfirebase/utils/utils.dart';
import 'package:finallyfirebase/widgets/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
   const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final verifyCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verify'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: verifyCodeController,
                decoration: const InputDecoration(
                  hintText: '6 digit code',
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              RoundButton(
                  title: 'Verify',
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    final token = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: verifyCodeController.text.toString());
                   //try catch for any exception
                    try {
                      await auth.signInWithCredential(token);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const PostsScreen()));
                    }
                    catch(e) {
                      setState(() {
                        loading = false;
                        Utils().toastMessage(e.toString());
                      });
                    }
                  },
                  loading: loading)
            ],
          ),
        ));
  }
}
