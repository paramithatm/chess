import 'package:chess/engine/move.dart';
import 'package:chess/engine/piece.dart';
import 'package:chess/engine/square.dart';

abstract interface class Castling {
  // all square between rook and king
  List<Square> get mustBeEmpty;

  // only square where king will walk to (1-2 step to right/left)
  List<Square> get mustBeUnattacked;

  Square get kingMoveTo;
  Move get rookMoves;
  
  Square get rookHomeSquare;

  PieceColor get color;
}

enum CastlingStatus implements Castling {
  blackQueenSide,
  blackKingSide,
  whiteQueenSide,
  whiteKingSide;

  @override
  List<Square> get mustBeEmpty => switch (this) {
    .whiteKingSide =>[Square(5,0), Square(6,0)],
    .whiteQueenSide => [Square(1,0), Square(2,0), Square(3,0)],
    .blackKingSide => [Square(5,7), Square(6,7)],
    .blackQueenSide => [Square(1,7), Square(2,7), Square(3,7)]
  };

  @override
  List<Square> get mustBeUnattacked => switch (this) {
    .whiteKingSide =>[Square(5,0), Square(6,0)],
    .whiteQueenSide => [Square(2,0), Square(3,0)],
    .blackKingSide => [Square(5,7), Square(6,7)],
    .blackQueenSide => [Square(2,7), Square(3,7)]
  };

  @override Square get kingMoveTo => switch (this) {
    .whiteKingSide => Square(6,0),
    .whiteQueenSide => Square(2,0),
    .blackKingSide => Square(6,7),
    .blackQueenSide => Square(2,7)
  };

  @override Move get rookMoves => switch (this) {
    .whiteKingSide => Move(Square(7,0), Square(5,0)),
    .whiteQueenSide => Move(Square(0,0), Square(3,0)),
    .blackKingSide => Move(Square(7,7), Square(5,7)),
    .blackQueenSide => Move(Square(0,7), Square(3,7))
  };

  @override PieceColor get color => switch (this) {
    .whiteKingSide => .white,
    .whiteQueenSide => .white,
    .blackKingSide => .black, 
    .blackQueenSide => .black
  };

  @override Square get rookHomeSquare => switch (this) {
    .whiteKingSide => Square(7,0),
    .whiteQueenSide => Square(0,0),
    .blackKingSide => Square(7,7), 
    .blackQueenSide => Square(0,7),
  };
}