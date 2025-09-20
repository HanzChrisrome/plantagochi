import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:plantagochi/screens/water_mini_game/splash_screen.dart';
import 'package:plantagochi/screens/water_mini_game/water_mini_game.dart';
import 'package:plantagochi/widgets/background_widget.dart';
import 'package:plantagochi/widgets/plant_widget.dart';
import 'package:plantagochi/widgets/status_bar.dart';

class PlantScreen extends StatefulWidget {
  const PlantScreen({super.key});

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  int waterLevel = 0;
  late AudioPlayer _player;
  Image healthMeterImage =
      Image.asset('assets/bars/HEALTH METER.png', width: 200, height: 200);
  Image waterMeterImage =
      Image.asset('assets/bars/WATER METER.png', width: 200, height: 200);

  void waterPlant() {
    setState(() {
      waterLevel += 1;
    });
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    _player.setReleaseMode(ReleaseMode.loop);
    _player.play(AssetSource('sfx/water_mini_game_bg.mp3'));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          const BackgroundWidget(
              imagePath: 'assets/images/cactus/Cactus (Background).png'),
          const PlantWidget(gifPath: 'assets/images/cactus/cactus_moving.gif'),

          Positioned(
            left: -55, // distance from left edge
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusBar(
                    status: 0,
                    statusBarImage: healthMeterImage,
                  ),
                  const SizedBox(height: 20),
                  StatusBar(
                    status: 0,
                    statusBarImage: waterMeterImage,
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Row(
                children: [
                  Image.asset(
                    'assets/hud/day_indicator.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(width: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/hud/DEFAULT PLACEHOLDER.png',
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        'Day 1', // your custom text
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.7),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/hud/DEFAULT PLACEHOLDER.png',
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        'Day 1', // your custom text
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              // optional: makes text pop out
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.7),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40), // move up by 40px
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const WaterSplashScreen()),
                      ).then((_) {
                        _player.resume();
                      });
                    },
                    child: Image.asset(
                      'assets/buttons/water_plant_btn.png',
                      width: 95,
                      height: 95,
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      'assets/buttons/clear_plant_btn.png',
                      width: 95,
                      height: 95,
                    ),
                  ),
                ],
              ),
            ),
          )

          // HUD / Water button
          // Positioned(
          //   bottom: 20,
          //   left: 20,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       ElevatedButton(
          //         onPressed: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (_) => const WaterMiniGame()),
          //           ).then((_) {
          //             _player.resume();
          //           });
          //         },
          //         child: const Text('Water Plant'),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
