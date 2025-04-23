import 'package:daa_project/Auth/Log_In.dart';
import 'package:daa_project/Helper/helper.dart';
import 'package:daa_project/Home_Page.dart';
import 'package:daa_project/Text_Field/Text_field.dart';
import 'package:daa_project/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _userController = TextEditingController();

  void registerUser() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (_passwordController.text != _confirmPasswordController) {
      Navigator.pop(context);
      displayMessageToUser("Passwords don't match", context);
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      print("User Registered: ${userCredential.user?.email}");

      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading dialog

      if (e.code == 'email-already-in-use') {
        displayMessageToUser("Email is already registered!", context);
      } else if (e.code == 'weak-password') {
        displayMessageToUser("Password is too weak!", context);
      } else {
        displayMessageToUser(e.message ?? "An error occurred", context);
      }
    }
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _userController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up', 
      style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 36,
      color: const Color.fromARGB(255, 2, 75, 201)),),),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
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
                  const SizedBox(height: 30),
                  MyTextField(
                    hintText: "User Name",
                    obscureText: false,
                    controller: _userController,
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    hintText: "Email",
                    obscureText: false,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    hintText: "Password",
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    hintText: "Confirm Password",
                    obscureText: true,
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: registerUser,
                    child: Container(
                      height: 50,
                      width: 140,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: const Color.fromARGB(255, 2, 75, 201)),
                      child: const Center(
                        child: Text(
                          'Sign Up',
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
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogIn(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: const Color.fromARGB(255, 2, 75, 201)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ]
        ),
      ),
    );
  }
}


