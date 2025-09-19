import 'package:flutter/material.dart';
import 'package:plantagochi/water_mini_game/water_mini_game.dart';

void main() {
  runApp(const GreenBuddyApp());
}

class GreenBuddyApp extends StatelessWidget {
  const GreenBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlantScreen(),
    );
  }
}

class PlantScreen extends StatefulWidget {
  const PlantScreen({super.key});

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  int waterLevel = 0;

  void waterPlant() {
    setState(() {
      waterLevel += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/sample.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Moving plant (GIF)
          Positioned(
            left: 100,
            bottom: 50,
            child: Image.asset(
              'assets/images/sunflower.png',
              width: 150,
              height: 150,
            ),
          ),

          // HUD / Water button
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WaterMiniGame()),
                    );
                  },
                  child: const Text('Water Plant'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
