import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game/game/arena.dart';
import 'package:game/game/items/ball.dart';
import 'package:game/game/items/brick_wall.dart';
import 'package:flame/extensions.dart';
import 'package:game/game/items/paddle.dart';

class MyGame extends Forge2DGame with HasDraggables  {

  MyGame() : super(gravity: Vector2(0.0, 0.0), zoom: 20);

  late final Ball _ball;

  @override
  Future<void> onLoad() async {
    await _initializeGame();

    _ball.body.applyLinearImpulse(Vector2(-10, -10));
  }

  Future<void> _initializeGame() async {

    final arena = Arena();
    await add(arena);

    final brickWallPosition = Vector2(0.0, size.y * 0.075);

    final brickWall = BrickWall(
      position: brickWallPosition,
      rows: 8,
      columns: 6,
    );
    await add(brickWall);

    _ball = Ball(
      radius: 0.5,
      position: size / 2,
    );
    await add(_ball);

    const paddleSize = Size(4.0, 0.8);
  final paddlePosition = Vector2(
   size.x / 2.0,
   size.y * 0.85,
  );

  final paddle = Paddle(
   size: paddleSize,
   position: paddlePosition,
  );
  await add(paddle);

  }
}