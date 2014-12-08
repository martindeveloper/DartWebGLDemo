import 'dart:html';
import 'Game.dart';

void main() {
  final CanvasElement canvas = querySelector("#viewport");

  final Game game = new Game(canvas);

  ButtonElement startButton = querySelector("#start")
    ..onClick.listen((MouseEvent event) {
    game.Run(EntitiesManager.CreateList());
  });

  ButtonElement stopButton = querySelector("#stop")
    ..onClick.listen((MouseEvent event) {
    game.Stop();
  });
}