import 'package:finallyfirebase/ui/auth/verify_code.dart';
import 'package:finallyfirebase/utils/utils.dart';
import 'package:finallyfirebase/widgets/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNUmber extends StatefulWidget {
  const LoginWithPhoneNUmber({super.key});

  @override
  State<LoginWithPhoneNUmber> createState() => _LoginWithPhoneNUmberState();
}

class _LoginWithPhoneNUmberState extends State<LoginWithPhoneNUmber> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login with phone number'),
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
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  hintText: '+1 234 456 364',
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              RoundButton(
                  title: 'Login with phone number',
                  onTap: () {
                    setState(() {
                      loading = true;
                    });

                    auth.verifyPhoneNumber(
                        phoneNumber: phoneNumberController.text,
                        verificationCompleted: (_) {
                          setState(() {
                            loading = false;
                          });
                        },
                        verificationFailed: (e) {
                          Utils().toastMessage(e.toString());
                        },
                        codeSent: (String verificationId, int? token) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerifyCodeScreen(
                                        verificationId: verificationId,
                                      )));
                       setState(() {
                         loading = false;
                       });
                        },
                        codeAutoRetrievalTimeout: (e) {
                          Utils().toastMessage(e.toString());
                        setState(() {
                          loading = false;
                        });
                        });
                  },
                  loading: loading)
            ],
          ),
        ));
  }
}
