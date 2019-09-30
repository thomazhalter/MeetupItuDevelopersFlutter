import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/time.dart';

import 'dart:math';

void main() async {
  final size = await Flame.util.initialDimensions();

  final game = MyGame(size);
  runApp(game.widget);

  Flame.util.addGestureRecognizer(TapGestureRecognizer()
    ..onTapDown = (TapDownDetails e) {
      game.stopPlayer();
    }
    ..onTapUp = (TapUpDetails e) {
      game.resumePlayer();
    });
}

class MyGame extends Game {
  static final Paint _white = Paint()..color = Color(0xFFFFFFFF);
  static final Paint _black = Paint()..color = Color(0xFF000000);

  static final Random random = Random();

  bool _playerMoving = true;
  int _playerDirection = 1;
  Rect _player;

  List<Rect> _enemies = [];

  Size _screenSize;

  Timer _enemieCreator;

  MyGame(this._screenSize) {
    _player = Rect.fromLTWH(
        (_screenSize.width / 2 - 25), _screenSize.height - 200, 50, 50);

    _enemieCreator = Timer(2.5, repeat: true, callback: () {
      _enemies.add(Rect.fromLTWH(
          random.nextInt(_screenSize.width.toInt() - 50).toDouble(),
          -25,
          50,
          50));
    });
    _enemieCreator.start();
  }

  void stopPlayer() {
    _playerMoving = false;
  }

  void resumePlayer() {
    _playerMoving = true;
  }

  @override
  void update(double dt) {
    _enemieCreator.update(dt);

    if (_playerMoving) {
      _player = _player.translate(1000 * dt * _playerDirection, 0);

      if (_player.right >= _screenSize.width && _playerDirection == 1) {
        _playerDirection = -1;
      }

      if (_player.left <= 0 && _playerDirection == -1) {
        _playerDirection = 1;
      }
    }

    bool lose = false;
    for (var i = 0; i < _enemies.length; i++) {
      _enemies[i] = _enemies[i].translate(0, 250 * dt);

      if (_enemies[i].overlaps(_player)) {
        lose = true;
      }
    }

    if (lose) {
      _enemies = [];
    }

    _enemies.removeWhere((rect) => rect.top >= _screenSize.height);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
        Rect.fromLTWH(0, 0, _screenSize.width, _screenSize.height), _white);
    canvas.drawRect(_player, _black);

    _enemies.forEach((rect) {
      canvas.drawRect(rect, _black);
    });
  }
}
