library Game;

// Dart libs
import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:web_gl';
import 'dart:typed_data';

// Game "engine" parts
part 'Game/GameLoop.dart';
part 'Game/GameTime.dart';
part 'Game/EntitiesManager.dart';

// Entities
part 'Game/Entities/IEntity.dart';
part 'Game/Entities/TriangleEntity.dart';

/// Main game class
/// Game class can run game loop with specified entities
/// Game loop and WebGL context are private properties to Game library
class Game {
  RenderingContext _GlContext;
  GameLoop _Loop;
  static bool IsDebugEnabled = false;

  Game(CanvasElement targetCanvas) {
    _GlContext = targetCanvas.getContext3d();

    if (_GlContext == null) {
      throw new ArgumentError("Can not get 3D context on target canvas!");
    }
  }

  Run(List<IEntity> entities) {
    _Loop = new GameLoop(_GlContext);

    _Loop.Start(entities);
  }

  Stop() {
    if (_Loop != null) {
      _Loop.Stop();
      _Loop.Clear();
    } else {
      throw new StateError("Game is not started yet!");
    }
  }
}