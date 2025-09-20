import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:plantagochi/models/drop.dart';
import 'package:plantagochi/screens/water_mini_game/asset_manager.dart';
import 'package:plantagochi/screens/water_mini_game/drop_widget.dart';
import 'package:plantagochi/screens/water_mini_game/game_state.dart';
import 'package:plantagochi/screens/water_mini_game/hud/health_bar.dart';
import 'package:plantagochi/screens/water_mini_game/hud/water_meter.dart';
import 'package:plantagochi/screens/water_mini_game/overlays/game_complete_overlay.dart';
import 'package:plantagochi/screens/water_mini_game/overlays/game_over_overlay.dart';

class WaterMiniGame extends StatefulWidget {
  const WaterMiniGame({super.key});

  @override
  State<WaterMiniGame> createState() => _WaterMiniGameState();
}

class _WaterMiniGameState extends State<WaterMiniGame>
    with SingleTickerProviderStateMixin {
  final GameState game = GameState();
  final AssetsManager assets = AssetsManager();
  late AudioPlayer _player;

  bool _assetsLoaded = false;
  bool _winSoundPlayed = false;

  double plantXposition = 0.4;
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      assets.loadAssets(context);

      _player = AudioPlayer();
      _player.setReleaseMode(ReleaseMode.loop);
      _player.play(AssetSource('sfx/water_mini_game_bg.mp3'));

      setState(() {
        _assetsLoaded = true;
        game.reset();
      });
    });
    _ticker = createTicker(_update)..start();
  }

  void _update(Duration elapsed) {
    final dt = (elapsed - _lastTick).inMilliseconds / 1000.0;
    _lastTick = elapsed;
    if (game.isGameOver || game.isCompleted) return;

    bool caughtWaterThisFrame = false;
    bool caughtAcidThisFrame = false;

    setState(() {
      for (var drop in game.drops) {
        const speed = 0.5;
        drop.y += speed * dt;

        const catcherZoneTop = 0.80;
        const catcherZoneBottom = 0.90;

        if (drop.y >= catcherZoneTop &&
            drop.y <= catcherZoneBottom &&
            (drop.x - plantXposition).abs() < 0.05 &&
            drop.active) {
          if (drop.type == DropType.water) {
            game.waterCollected++;
            caughtWaterThisFrame = true;
          } else if (drop.type == DropType.acid) {
            game.playerHealthBar--;
            caughtAcidThisFrame = true;
          }
          drop.active = false;
        }

        if (drop.y > catcherZoneBottom && drop.active) drop.active = false;

        if (drop.y > 1.0) {
          drop.x = game.random.nextDouble() * 0.9;
          drop.y = game.random.nextDouble() * -1.0;
          drop.active = true;
        }
      }
    });

    if (caughtWaterThisFrame) {
      assets.playSfx('water_catch.mp3');
    }
    if (caughtAcidThisFrame) {
      assets.playSfx('acid_catch.mp3');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _ticker.dispose();
    assets.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (!_assetsLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (game.isCompleted && !_winSoundPlayed) {
      _winSoundPlayed = true;
      assets.playSfx('achieved.ogg');
    }

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (!game.isGameOver && !game.isCompleted) {
            setState(() {
              plantXposition += details.delta.dx / screenWidth;
              plantXposition = plantXposition.clamp(0.0, 0.9);
            });
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: assets.backgroundImage,
            ),
            for (var drop in game.drops)
              DropWidget(
                drop: drop,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                waterImage: assets.rainDropImage,
                acidImage: assets.acidDropImage,
              ),
            Positioned(
              bottom: 50,
              left: 0,
              child: Transform.translate(
                offset: Offset(screenWidth * plantXposition, 0),
                child: assets.catcherImage,
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
                    HealthBar(
                        health: game.playerHealthBar,
                        heartImage: assets.heartImage),
                    GestureDetector(
                        onTap: () => setState(() => game.reset()),
                        child: assets.retryImage),
                  ],
                ),
              ),
            ),
            WaterMeter(
              collected: game.waterCollected,
              meterImage: assets.waterMeterImage,
            ),
            if (game.isCompleted)
              GameCompletedOverlay(
                completedImage: assets.completedImage,
                proceedImage: assets.proceedImage,
                onProceed: () {},
              ),
            if (game.isGameOver)
              GameOverOverlay(
                gameOverImage: assets.gameOverImage,
                retryImage: assets.retryImage,
                proceedImage: assets.proceedImage,
                onRetry: () => setState(() => game.reset()),
                onProceed: () {},
              ),
          ],
        ),
      ),
    );
  }
}
