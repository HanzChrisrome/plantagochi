import 'package:flutter/material.dart';

class WaterMeter extends StatelessWidget {
  final int collected;
  final Image meterImage;

  const WaterMeter(
      {super.key, required this.collected, required this.meterImage});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 5,
              child: Container(
                width: 40,
                height: 225 * (collected / 10),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            meterImage,
          ],
        ),
      ),
    );
  }
}
