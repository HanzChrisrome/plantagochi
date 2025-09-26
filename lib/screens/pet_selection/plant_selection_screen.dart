import 'package:flutter/material.dart';
import 'package:plantagochi/widgets/background_widget.dart';
import 'package:plantagochi/widgets/wood_choice_banner.dart';

class PlantSelectionScreen extends StatefulWidget {
  const PlantSelectionScreen({super.key});

  @override
  State<PlantSelectionScreen> createState() => _PlantSelectionScreenState();
}

class _PlantSelectionScreenState extends State<PlantSelectionScreen> {
  final List<String> seedImages = [
    'assets/seeds/sunflower.png',
    'assets/seeds/narra.png',
    'assets/seeds/cactus.png',
  ];
  final List<String> seedNames = ['Sunny', 'Narra', 'Cactus'];

  int currentSeedIndex = 0;

  void showNextSeed() {
    setState(() {
      currentSeedIndex = (currentSeedIndex + 1) % seedImages.length;
    });
  }

  void showPreviousSeed() {
    setState(() {
      currentSeedIndex =
          (currentSeedIndex - 1 + seedImages.length) % seedImages.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundWidget(
            imagePath: 'assets/images/background/CHARACTER PICK.png',
          ),
          Positioned(
            top: 40, // Adjust this value to control vertical position
            left: 0,
            right: 0,
            child: Center(
              child: WoodChoiceBanner(
                title: 'Choose ${seedNames[currentSeedIndex]}',
                onYes: () {},
                onNo: () {},
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/hud/PLATFORM.png',
                width: 450,
                height: 450,
              ),
            ),
          ),
          Positioned(
            bottom: 250,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                seedImages[currentSeedIndex],
                width: 350,
                height: 350,
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              children: [
                // Left half
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: showPreviousSeed,
                    child: const SizedBox.expand(),
                  ),
                ),
                // Right half
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: showNextSeed,
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
