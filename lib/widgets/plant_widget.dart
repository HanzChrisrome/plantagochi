import 'package:flutter/material.dart';

class PlantWidget extends StatelessWidget {
  final String gifPath;
  final double width;
  final double height;
  final double bottomPadding;

  const PlantWidget({
    super.key,
    required this.gifPath,
    this.width = 1200,
    this.height = 1200,
    this.bottomPadding = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Image.asset(gifPath, width: width),
      ),
    );
  }
}
