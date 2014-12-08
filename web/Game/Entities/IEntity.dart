part of Game;

abstract class IEntity {
  void PrepareRendering(RenderingContext GlContext);

  void OnStart();

  void OnUpdate(GameTime time);

  void OnFixedUpdate();

  void OnDestroy();
}