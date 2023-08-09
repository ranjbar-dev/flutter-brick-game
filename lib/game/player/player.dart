import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game/game/game.dart';

enum PlayerState {
  duck,
  fall,
  idle,
  jump,
  walk,
}

class Player extends BodyComponent<MyGame> with KeyboardHandler {
  double moveSpeed = 20;

  double jumpPower = 40;

  int accelerationX = 0;

  int accelerationY = 0;

  bool isDucking = false;

  void idle() {
    accelerationX = 0;
    isDucking = false;
  }

  void walkLeft() {
    accelerationX = -1;
  }

  void walkRight() {
    accelerationX = 1;
  }

  void duck() {
    isDucking = true;
  }

  void jump() {
    if (state == PlayerState.jump || state == PlayerState.fall) {
      return;
    }

    accelerationY = 1;
    state = PlayerState.jump;
  }

  final _componentPosition = Vector2(0, -10);
  final _size = Vector2(20, 20);
  PlayerState state = PlayerState.idle;

  late Component currentComponent;
  late final SpriteComponent duckComponent;
  late final SpriteComponent fallComponent;
  late final SpriteComponent idleComponent;
  late final SpriteComponent jumpComponent;
  late final SpriteAnimationComponent walkComponent;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(gameRef.size.x / 2, gameRef.size.y - 3),
      type: BodyType.dynamic,
    );

    final shape = PolygonShape()..setAsBoxXY(_size.x / 2, .90);

    final fixtureDef = FixtureDef(shape)
      ..density = 10
      ..friction = 0
      ..restitution = 0;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    renderBody = false;

    final duck = await gameRef.loadSprite('player/duck.png');
    final fall = await gameRef.loadSprite('player/fall.png');
    final idle = await gameRef.loadSprite('player/idle.png');
    final jump = await gameRef.loadSprite('player/jump.png');
    final walk0 = await gameRef.loadSprite('player/walk0.png');
    final walk1 = await gameRef.loadSprite('player/walk1.png');
    final walk2 = await gameRef.loadSprite('player/walk2.png');
    final walk3 = await gameRef.loadSprite('player/walk3.png');
    final walk4 = await gameRef.loadSprite('player/walk4.png');
    final walk5 = await gameRef.loadSprite('player/walk5.png');
    final walk6 = await gameRef.loadSprite('player/walk6.png');
    final walk7 = await gameRef.loadSprite('player/walk7.png');

    duckComponent = SpriteComponent(
      sprite: duck,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    fallComponent = SpriteComponent(
      sprite: fall,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    idleComponent = SpriteComponent(
      sprite: idle,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    jumpComponent = SpriteComponent(
      sprite: jump,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    final walkAnimation = SpriteAnimation.spriteList([
      walk0,
      walk1,
      walk2,
      walk3,
      walk4,
      walk5,
      walk6,
      walk7,
    ], stepTime: 0.05, loop: true);

    walkComponent = SpriteAnimationComponent(
      animation: walkAnimation,
      anchor: Anchor.center,
      position: _componentPosition,
      size: _size,
      removeOnFinish: false,
    );

    currentComponent = idleComponent;
    add(idleComponent);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    final velocity = body.linearVelocity;

    // handle movement
    velocity.x = accelerationX * moveSpeed;

    // handle jump action
    if (accelerationY == 1) {
      velocity.y = -accelerationY * jumpPower;
      accelerationY = 0;
    }

    // update body velocity
    body.linearVelocity = velocity;

    if (velocity.y > 0.1) {
      state = PlayerState.fall;
    } else if (velocity.y < 0.1 && state != PlayerState.jump) {
      if (accelerationX != 0) {
        state = PlayerState.walk;
      } else if (isDucking) {
        state = PlayerState.duck;
      } else {
        state = PlayerState.idle;
      }
    }

    if (state == PlayerState.jump) {
      _setComponent(jumpComponent);
    } else if (state == PlayerState.fall) {
      _setComponent(fallComponent);
    } else if (state == PlayerState.walk) {
      _setComponent(walkComponent);
    } else if (state == PlayerState.duck) {
      _setComponent(duckComponent);
    } else if (state == PlayerState.idle) {
      _setComponent(idleComponent);
    }
  }

  void _setComponent(PositionComponent component) {
    if (accelerationX < 0) {
      if (!component.isFlippedHorizontally) {
        component.flipHorizontally();
      }
    } else {
      if (component.isFlippedHorizontally) {
        component.flipHorizontally();
      }
    }

    if (component == currentComponent) return;
    remove(currentComponent);
    currentComponent = component;
    add(component);
  }
}
