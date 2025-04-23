import 'package:daa_project/Auth/Log_In.dart';
import 'package:daa_project/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => LogIn(),));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 200,
          ),
          Lottie.asset('assets/Animation - 1741289221033.json'),
          SizedBox(height: 30),
          Text(
            "Ride Smart, Save Big, Travel Easy",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: const Color.fromARGB(255, 2, 75, 201)),
          )
        ],
      ),
    );
  }
}
