import 'package:finallyfirebase/ui/auth/loginscreen.dart';
import 'package:finallyfirebase/utils/utils.dart';
import 'package:finallyfirebase/widgets/roundbutton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final _formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //getting instances from firebase
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.dispose();
    emailController.dispose();
  }
void signUp(){ if (_formField.currentState!.validate()) {
  setState(() {
    loading = true;
  });
  _auth.createUserWithEmailAndPassword(
      email: emailController.text.toString(),
      password: passwordController.text.toString())
      .then((value) { setState(() {
    loading = false;
  });})
      .onError((error, stackTrace) {
    Utils().toastMessage(error.toString());
    setState(() {
      loading = false;
    });
  });
}}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(
          child: Text('Sign Up'),
        )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formField,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.alternate_email_outlined)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Email';
                        }
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'password',
                          prefixIcon: Icon(Icons.lock_outlined)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Password';
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              RoundButton(
                title: 'Sign up',
                loading: loading,
                onTap: () {
                  signUp();
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text('Login'))
                ],
              ),
            ],
          ),
        ));
  }
}
