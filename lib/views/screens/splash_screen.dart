import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  navigateTo() async {
    Future.delayed(const Duration(seconds: 3), () {
<<<<<<< HEAD
      Navigator.pushReplacementNamed(context, 'signInScreen');
=======
      Navigator.pushReplacementNamed(context, 'logSignPage');
>>>>>>> main
    });
  }

  @override
  void initState() {
    navigateTo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.red.shade200,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.5,
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 3, end: 1),
                duration: const Duration(seconds: 1),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 2, end: 0),
                      duration: const Duration(seconds: 5),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.rotate(
                          angle: value,
                          child: Image.asset('assets/images/logo/logo.png'),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Text(
              'LifeTech',
              style: GoogleFonts.lobster(
                color: Colors.red.shade900,
                letterSpacing: 0,
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
