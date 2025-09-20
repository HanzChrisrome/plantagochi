import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantagochi/screens/water_mini_game/water_mini_game.dart';

class WaterSplashScreen extends StatefulWidget {
  const WaterSplashScreen({super.key});

  @override
  State<WaterSplashScreen> createState() => _WaterSplashScreenState();
}

class _WaterSplashScreenState extends State<WaterSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setReleaseMode(ReleaseMode.loop);
    _player.play(AssetSource('sfx/water_mini_game_bg.mp3'));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _player.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WaterMiniGame()),
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background splash image
            SizedBox.expand(
              child: Image.asset(
                'assets/splash/SPLASH MINI GAME.png',
                fit: BoxFit.cover,
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: FadeTransition(
                  opacity: _animation,
                  child: Text(
                    "TAP TO START",
                    style: GoogleFonts.pressStart2p(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
