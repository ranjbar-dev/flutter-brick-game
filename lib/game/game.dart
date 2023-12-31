import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:game/game/arena.dart';
import 'package:game/game/player/player.dart';
import 'package:game/platform/platform.dart';

class MyGame extends Forge2DGame with HasKeyboardHandlerComponents {
  MyGame() : super(gravity: Vector2(0.0, 100.0), zoom: 20);

  late Player player;
  late Arena arena;

  @override
  Future<void> onLoad() async {
    await _initializeGame();
  }

  Future<void> _initializeGame() async {
    arena = Arena();
    await add(arena);

    player = Player();
    await add(player);

    var platform = Platform(x: size.x / 3, y: size.y / 1.1);
    await add(platform);

    camera.followBodyComponent(player);
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);

    // handle jump
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyW) {
        player.jump();
      }
    }

    // handle right/left move
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      player.walkRight();
    } else if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      player.walkLeft();
    } else if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      player.duck();
    } else {
      player.idle();
    }

    return KeyEventResult.handled;
  }
}
