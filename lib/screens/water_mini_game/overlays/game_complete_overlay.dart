// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class GameCompletedOverlay extends StatelessWidget {
  final Image completedImage;
  final Image proceedImage;
  final VoidCallback onProceed;

  const GameCompletedOverlay({
    super.key,
    required this.completedImage,
    required this.proceedImage,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              completedImage,
              const SizedBox(height: 20),
              GestureDetector(onTap: onProceed, child: proceedImage),
            ],
          ),
        ),
      ),
    );
  }
}
