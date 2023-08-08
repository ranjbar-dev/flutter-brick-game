import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game/game/game.dart';

class Ball extends BodyComponent<MyGame> {

  final Vector2 position;
  final double radius;

  Ball({required this.position, required this.radius});

  @override
  Body createBody() {

    final bodyDef = BodyDef()
      ..userData = this
      ..type = BodyType.dynamic
      ..position = position;

    final ball = world.createBody(bodyDef);

    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(
      shape,
      restitution: 1.0,
      density: 1.0,
    );

    ball.createFixture(fixtureDef);
    return ball;
  }
}
