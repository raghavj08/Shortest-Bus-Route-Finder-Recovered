import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daa_project/Auth/Sign_Up.dart';
import 'package:daa_project/Helper/helper.dart';
import 'package:daa_project/Home_Page.dart';
import 'package:daa_project/Text_Field/Text_field.dart';
import 'package:daa_project/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      print("User Logged In: ${userCredential.user?.email}");

      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        displayMessageToUser("No user found with that e-mail id", context);
      } else if (e.code == "wrong password") {
        displayMessageToUser("Wrong Password. Try again", context);
      } else {
        displayMessageToUser(e.message ?? e.code, context);
      }
    }
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 36,
              color: const Color.fromARGB(255, 2, 75, 201)),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child:
                        Lottie.asset('assets/Animation - 1741289221033.json'),
                  ),
                  Positioned(
                    top: 170,
                    left: 37,
                    child: Text(
                      'RIDE  FLOW',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 2, 75, 201)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController),
              SizedBox(height: 20),
              MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: _passwordController),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Forgot Password?',
                      style: TextStyle(color: Colors.blue)),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: login,
                child: Container(
                  height: 50,
                  width: 140,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      color: Color.fromARGB(255, 2, 75, 201)),
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Do not have an account? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ),
                      );
                    },
                    child: const Text(
                      'Register Here',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 2, 75, 201)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
