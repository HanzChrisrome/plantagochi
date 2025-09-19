import 'package:flutter/material.dart';
import 'package:plantagochi/models/drop.dart';

class DropWidget extends StatelessWidget {
  final Drop drop;
  final double screenWidth;
  final double screenHeight;
  final Image waterImage;
  final Image acidImage;

  const DropWidget({
    super.key,
    required this.drop,
    required this.screenWidth,
    required this.screenHeight,
    required this.waterImage,
    required this.acidImage,
  });

  @override
  Widget build(BuildContext context) {
    if (!drop.active) return const SizedBox.shrink();

    return Positioned(
      top: screenHeight * drop.y,
      left: screenWidth * drop.x,
      child: drop.type == DropType.water ? waterImage : acidImage,
    );
  }
}
