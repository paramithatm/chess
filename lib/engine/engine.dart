import 'package:chess/engine/piece.dart';
import 'package:chess/engine/position.dart';
import 'package:chess/engine/square.dart';

void main() {
  print(Position.fromPieces({
    Square(0,0): Piece(.white, .knight)
  }));
}