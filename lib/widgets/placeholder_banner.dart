import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaceholderBanner extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final String imagePath;

  const PlaceholderBanner({
    super.key,
    required this.text,
    this.width = 100,
    this.height = 100,
    this.imagePath = 'assets/hud/DEFAULT PLACEHOLDER.png',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          imagePath,
          width: width,
          height: height,
        ),
        Text(
          text,
          style: GoogleFonts.pressStart2p(
            fontSize: width * 0.24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 4,
                color: Colors.black.withOpacity(0.7),
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
