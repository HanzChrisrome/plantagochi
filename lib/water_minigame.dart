// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:plantagochi/models/drop.dart';

class WaterMiniGame extends StatefulWidget {
  const WaterMiniGame({super.key});

  @override
  State<WaterMiniGame> createState() => _WaterMiniGameState();
}

class _WaterMiniGameState extends State<WaterMiniGame> {
  double plantXposition = 0.4;
  int score = 0;
  final List<Drop> drops = [];
  Timer? gameTimer;
  late DateTime lastUpdate;
  final Random random = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();

  //Water Bar Logic Variables:
  int waterCollected = 0;
  int playerHealthBar = 3;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
          const AssetImage('assets/images/background/sunflower_bg.png'),
          context);
      precacheImage(
          const AssetImage('assets/images/games/raindrops.png'), context);
      precacheImage(
          const AssetImage('assets/images/games/aciddrop.png'), context);
      precacheImage(
          const AssetImage('assets/images/games/raincatcher.png'), context);
      precacheImage(
          const AssetImage('assets/images/games/goodheart.png'), context);
      precacheImage(
          const AssetImage('assets/images/games/retrybutton.png'), context);
      precacheImage(
          const AssetImage('assets/images/games/WATER METER.png'), context);
      precacheImage(
          const AssetImage('assets/images/games/GAME COMPLETED.png'), context);
      precacheImage(
          const AssetImage('assets/images/games/proceed.png'), context);
      precacheImage(
          const AssetImage('assets/images/games/GAME OVER.png'), context);
    });

    startGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  //Functions:

  // First create the function that starts the game:
  void startGame() {
    gameTimer?.cancel();
    waterCollected = 0;
    playerHealthBar = 3;
    drops.clear();

    for (int i = 0; i < 3; i++) {
      drops.add(Drop(
        x: random.nextDouble() * 0.9,
        y: random.nextDouble() * -1.0,
        type: DropType.water,
      ));
    }

    for (int i = 0; i < 5; i++) {
      drops.add(Drop(
        x: random.nextDouble() * 0.9,
        y: random.nextDouble() * -1.0,
        type: DropType.acid,
      ));
    }

    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (playerHealthBar <= 0 || waterCollected >= 10) {
          gameTimer?.cancel();
          return;
        }

        for (var drop in drops) {
          const speed = 0.02;
          drop.y += speed;

          const double catcherZoneTop = 0.80;
          const double catcherZoneBottom = 0.90;

          if (drop.y >= catcherZoneTop &&
              drop.y <= catcherZoneBottom &&
              (drop.x - plantXposition).abs() < 0.05 &&
              drop.active) {
            if (drop.type == DropType.water) {
              score += 1;
              waterCollected += 1;
              _audioPlayer.play(AssetSource('sfx/water_catch.mp3'));
            } else if (drop.type == DropType.acid) {
              playerHealthBar -= 1;
              _audioPlayer.play(AssetSource('sfx/acid_catch.mp3'));
            }
            drop.active = false;
          }

          if (drop.y > catcherZoneBottom && drop.active) {
            drop.active = false;
          }

          if (drop.y > 1.0) {
            drop.x = random.nextDouble() * 0.9;
            drop.y = random.nextDouble() * -1.0;
            drop.active = true;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlue.shade100,
        child: gameScreen(),
      ),
    );
  }

  Widget gameScreen() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (playerHealthBar > 0 || waterCollected < 10) {
          setState(() {
            plantXposition += details.delta.dx / screenWidth;
            plantXposition = plantXposition.clamp(0.0, 0.9);
          });
        }
      },
      child: Stack(
        children: [
          // BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/sunflower_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // RAIN DROPS
          for (var drop in drops)
            if (drop.active)
              Positioned(
                top: screenHeight * drop.y,
                left: screenWidth * drop.x,
                child: drop.type == DropType.water
                    ? Image.asset(
                        'assets/images/games/raindrops.png',
                        width: 50,
                        height: 50,
                      )
                    : Image.asset(
                        'assets/images/games/aciddrop.png',
                        width: 50,
                        height: 50,
                      ),
              ),

          Positioned(
            bottom: 50,
            left: 0,
            child: Transform.translate(
              offset: Offset(screenWidth * plantXposition, 0),
              child: const Image(
                image: AssetImage('assets/images/games/raincatcher.png'),
                width: 80,
                height: 80,
              ),
            ),
          ),

          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      playerHealthBar,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Image.asset(
                          'assets/images/games/goodheart.png',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        score = 0;
                        plantXposition = 0.35;
                        drops.clear();
                        startGame();
                      });
                    },
                    child: Image.asset(
                      'assets/images/games/retrybutton.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Image positioned in the middle right of the screen
          Align(
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
                      height: 225 * (waterCollected / 10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/games/WATER METER.png',
                    height: 300,
                  ),
                ],
              ),
            ),
          ),

          //GAME OVER OVERLAY
          if (waterCollected == 10 && playerHealthBar > 0)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/games/GAME COMPLETED.png',
                        width: 300,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/games/proceed.png',
                          width: 80,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (playerHealthBar <= 0)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/games/GAME OVER.png',
                        width: 300,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                score = 0;
                                plantXposition = 0.35;
                                drops.clear();
                                startGame();
                              });
                            },
                            child: Image.asset(
                              'assets/images/games/retrybutton.png',
                              width: 80,
                            ),
                          ),
                          const SizedBox(width: 30),
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/games/proceed.png',
                              width: 80,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
