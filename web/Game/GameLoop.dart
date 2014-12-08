part of Game;

class GameLoop {
  bool IsRunning = false;
  bool IsStopRequested = false;

  double TickDelta;
  double TickNow;

  List<IEntity> Objects;
  GameTime Time;

  Timer FixedUpdateTimer;
  RenderingContext GlContext;

  GameLoop(this.GlContext);

  void Start(List<IEntity> entities) {
    print("GameLoop: Starting loop.");

    Objects = entities;
    IsRunning = true;
    Time = new GameTime();

    print("GameLoop: Dispatching OnStart event on entities.");
    for (IEntity entity in Objects) {
      entity.PrepareRendering(GlContext);
      entity.OnStart();
    }

    print("GameLoop: Starting fixed tick timer.");
    FixedUpdateTimer = new Timer.periodic(const Duration(milliseconds: 250), FixedTick); // 1000 / 4

    print("GameLoop: First tick dispatch.");
    Tick(0.0);
  }

  /// Tick is called every frame by browser animation frame.
  /// Tick call OnUpdate on entities and its depends on client PC performance
  void Tick(double time) {
    if (IsRunning) {
      window.animationFrame.then(Tick);

      Time.DeltaTime = (time - Time.TotalTime);
      Time.TotalTime = time;

      // TODO: Move to Camera class
      GlContext.clearColor(.2, .2, .2, 1.0);
      GlContext.clear(RenderingContext.COLOR_BUFFER_BIT);

      // Enable alpha blending
      GlContext.enable(RenderingContext.BLEND);
      GlContext.blendFunc(RenderingContext.SRC_ALPHA, RenderingContext.ONE_MINUS_SRC_ALPHA);

      for (IEntity entity in Objects) {
        entity.OnUpdate(Time);
      }

      if (IsStopRequested) {
        IsStopRequested = false;
        IsRunning = false;
      }
    }
  }

  /// Fixed tick is guaranteed to be invoke in specific time. Default value is 250ms
  void FixedTick(Timer sender) {
    if (IsRunning) {
      for (IEntity entity in Objects) {
        entity.OnFixedUpdate();
      }
    }
  }

  void Stop() {
    print("GameLoop: Stopping loop.");

    IsStopRequested = true;
    FixedUpdateTimer.cancel();
  }

  void Clear() {
    print("GameLoop: Clearing objects.");

    ClearObjects();
  }

  /// Calls OnDestroy on all active entities and clear list
  void ClearObjects() {
    for (IEntity entity in Objects) {
      entity.OnDestroy();
    }

    Objects.clear();
  }
}