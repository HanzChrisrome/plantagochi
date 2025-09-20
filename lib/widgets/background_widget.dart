import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final String imagePath;
  const BackgroundWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );
  }
}
