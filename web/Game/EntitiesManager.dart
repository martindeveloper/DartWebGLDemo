part of Game;

class EntitiesManager {
  static List<IEntity> CreateList() {
    List<IEntity> entities = new List();

    entities.add(new TriangleEntity());

    return entities;
  }
}