import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  final int status;
  final Image statusBarImage;

  const StatusBar({
    super.key,
    required this.status,
    required this.statusBarImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: 5,
          child: Container(
            width: 40,
            height: 225 * (status / 10),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        statusBarImage,
      ],
    );
  }
}
