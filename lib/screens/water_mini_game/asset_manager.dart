import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AssetsManager {
  late final Image rainDropImage;
  late final Image acidDropImage;
  late final Image catcherImage;
  late final Image heartImage;
  late final Image retryImage;
  late final Image waterMeterImage;
  late final Image completedImage;
  late final Image proceedImage;
  late final Image gameOverImage;
  late final Image backgroundImage;

  final AudioPlayer _bgmPlayer = AudioPlayer();

  final List<AudioPlayer> _sfxPlayers = List.generate(5, (_) => AudioPlayer());

  Future<void> loadAssets(BuildContext context) async {
    rainDropImage =
        Image.asset('assets/images/games/raindrops.png', width: 50, height: 50);
    acidDropImage =
        Image.asset('assets/images/games/aciddrop.png', width: 50, height: 50);
    catcherImage = Image.asset('assets/images/games/raincatcher.png',
        width: 80, height: 80);
    heartImage =
        Image.asset('assets/images/games/goodheart.png', width: 32, height: 32);
    retryImage = Image.asset('assets/images/games/retrybutton.png',
        width: 60, height: 60);
    waterMeterImage = Image.asset('assets/bars/WATER METER.png', height: 300);
    completedImage =
        Image.asset('assets/images/games/GAME COMPLETED.png', width: 300);
    proceedImage = Image.asset('assets/images/games/proceed.png', width: 80);
    gameOverImage =
        Image.asset('assets/images/games/GAME OVER.png', width: 300);
    backgroundImage = Image.asset(
      'assets/images/background/water_minigame_bg.png',
      fit: BoxFit.cover,
    );

    for (var img in [
      rainDropImage,
      acidDropImage,
      catcherImage,
      heartImage,
      retryImage,
      waterMeterImage,
      completedImage,
      proceedImage,
      gameOverImage,
      backgroundImage,
    ]) {
      await precacheImage(img.image, context);
    }
  }

  Future<void> playSfx(String fileName) async {
    final player = _sfxPlayers.firstWhere(
      (p) => p.state != PlayerState.playing,
      orElse: () => _sfxPlayers[0],
    );
    await player.play(AssetSource('sfx/$fileName'));
  }

  Future<void> playBgm(String fileName) async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.play(AssetSource('sfx/$fileName'));
  }

  Future<void> pauseBgm() async {
    await _bgmPlayer.pause();
  }

  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
  }

  void dispose() {
    _bgmPlayer.dispose();
    for (var p in _sfxPlayers) {
      p.dispose();
    }
  }
}
