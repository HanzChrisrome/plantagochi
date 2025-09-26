import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WoodChoiceBanner extends StatelessWidget {
  final String title;
  final VoidCallback onYes;
  final VoidCallback onNo;

  const WoodChoiceBanner({
    super.key,
    required this.title,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Wooden frame background
        Image.asset(
          'assets/hud/DEFAULT PLACEHOLDER.png',
          width: 280,
          height: 300,
          fit: BoxFit.fill,
        ),
        // Texts inside
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.pressStart2p(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A2C0A), // dark brown
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onYes,
                  child: Text(
                    'YES',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: onNo,
                  child: Text(
                    'NO',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
