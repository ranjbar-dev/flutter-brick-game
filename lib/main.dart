import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game/game/game.dart';

void main() {
  final game = MyGame();
  runApp(GameWidget(game: game));
}
