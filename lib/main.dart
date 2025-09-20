import 'package:flutter/material.dart';
import 'package:plantagochi/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GreenBuddyApp());
}

class GreenBuddyApp extends StatelessWidget {
  const GreenBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
