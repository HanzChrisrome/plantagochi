import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:plantagochi/models/drop.dart';
import 'package:plantagochi/water_mini_game/asset_manager.dart';
import 'package:plantagochi/water_mini_game/drop_widget.dart';
import 'package:plantagochi/water_mini_game/game_state.dart';
import 'package:plantagochi/water_mini_game/hud/health_bar.dart';
import 'package:plantagochi/water_mini_game/hud/water_meter.dart';
import 'package:plantagochi/water_mini_game/overlays/game_complete_overlay.dart';
import 'package:plantagochi/water_mini_game/overlays/game_over_overlay.dart';
import 'package:video_player/video_player.dart';

class WaterMiniGame extends StatefulWidget {
  const WaterMiniGame({super.key});

  @override
  State<WaterMiniGame> createState() => _WaterMiniGameState();
}

class _WaterMiniGameState extends State<WaterMiniGame>
    with SingleTickerProviderStateMixin {
  final GameState game = GameState();
  final AssetsManager assets = AssetsManager();
  bool _assetsLoaded = false;

  double plantXposition = 0.4;
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;

  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _videoController =
        VideoPlayerController.asset('assets/images/games/moving_bg.mp4')
          ..initialize().then((_) {
            _videoController.setLooping(true);
            _videoController.setVolume(0);
            _videoController.play();
            setState(() {});
          });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      assets.loadAssets(context);
      assets.playBgm('water_mini_game_bg.mp3');
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
            if (_videoController.value.isInitialized)
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController.value.size.width,
                    height: _videoController.value.size.height,
                    child: VideoPlayer(_videoController),
                  ),
                ),
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
