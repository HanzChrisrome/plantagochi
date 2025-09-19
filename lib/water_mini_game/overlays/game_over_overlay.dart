// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final Image gameOverImage;
  final Image retryImage;
  final Image proceedImage;
  final VoidCallback onRetry;
  final VoidCallback onProceed;

  const GameOverOverlay({
    super.key,
    required this.gameOverImage,
    required this.retryImage,
    required this.proceedImage,
    required this.onRetry,
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
              gameOverImage,
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onRetry,
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: retryImage,
                    ),
                  ),
                  const SizedBox(width: 30),
                  GestureDetector(onTap: onProceed, child: proceedImage),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
