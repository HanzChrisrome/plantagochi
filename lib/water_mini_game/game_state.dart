import 'dart:math';

import 'package:plantagochi/models/drop.dart';

class GameState {
  int waterCollected = 0;
  int playerHealthBar = 3;
  final Random random = Random();

  final List<Drop> drops = [];

  void reset() {
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
  }

  bool get isGameOver => playerHealthBar <= 0;
  bool get isCompleted => waterCollected >= 10 && playerHealthBar > 0;
}
