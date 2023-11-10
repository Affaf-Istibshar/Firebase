import 'package:finallyfirebase/ui/auth/loginwithphonenumber.dart';
import 'package:finallyfirebase/ui/auth/signup.dart';
import 'package:finallyfirebase/ui/firestore/firestore_list_screen.dart';
import 'package:finallyfirebase/ui/posts/postsScreen.dart';
import 'package:finallyfirebase/utils/utils.dart';
import 'package:finallyfirebase/widgets/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.dispose();
    emailController.dispose();
  }

  void Login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) {
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(
          context,
          //Navigation to posts screen or Firestore screen
          // MaterialPageRoute(builder: (context) => PostsScreen())
          MaterialPageRoute(builder: (context) => FirestoreScreen())
      );
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Center(
                  child: Text('Login'),
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
                    title: 'Login',
                    loading: loading,
                    onTap: () {
                      if (_formField.currentState!.validate()) {
                        Login();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                          },
                          child: Text('Sign up'))
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginWithPhoneNUmber()));
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black)),
                      child: Center(
                        child: Text('Login with phone number'),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
