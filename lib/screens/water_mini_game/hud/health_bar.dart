import 'package:flutter/material.dart';

class HealthBar extends StatelessWidget {
  final int health;
  final Image heartImage;

  const HealthBar({super.key, required this.health, required this.heartImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        health,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: heartImage,
        ),
      ),
    );
  }
}
