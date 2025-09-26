import 'package:flutter/material.dart';
import 'package:plantagochi/screens/pet_selection/plant_selection_screen.dart';
import 'dart:async';
import 'package:plantagochi/screens/plant_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PlantSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/SPLASH SCREEN.png',
          fit: BoxFit.cover, // full-screen
        ),
      ),
    );
  }
}
