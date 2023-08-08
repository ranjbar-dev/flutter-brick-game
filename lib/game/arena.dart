import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game/game/game.dart';

class Arena extends BodyComponent<MyGame> {
  Vector2? size;

  Arena({this.size}) {
    assert(size == null || size!.x >= 1.0 && size!.y >= 1.0);
  }

  late Vector2 arenaSize;

  @override
  Future<void> onLoad() {
    arenaSize = size ?? gameRef.size;
    return super.onLoad();
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: Vector2(0, 0),
       type: BodyType.static,
    );

    final arenaBody = world.createBody(bodyDef);

    final vertices = <Vector2>[
      arenaSize,
      Vector2(0, arenaSize.y),
      Vector2(0, 0),
      Vector2(arenaSize.x, 0),
    ];

    final chain = ChainShape()..createLoop(vertices);

    for (var index = 0; index < chain.childCount; index++) {
      arenaBody.createFixture(FixtureDef(
        chain.childEdge(index),
        density: 2000.0,
        friction: 0.0,
        restitution : 1.0,
      ));
    }

    return arenaBody;
  }
}
