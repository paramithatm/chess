import 'package:chess/engine/direction.dart';
import 'package:chess/engine/piece.dart';
import 'package:chess/engine/position.dart';
import 'package:chess/engine/square.dart';

// status of square x, depending on position and whose turn is it
enum _SquareStatus {
  empty,
  ally,
  enemy,
  offBoard;
}

// Move generation lives here as an extension on Position: it only needs the
// public `pieceAt`, so it stays out of the core Position class. Keeps Position
// focused on board state; keeps these helpers (and _SquareStatus) private here.
extension MoveGeneration on Position {
  // MARK: - Move generation
  // valid moves: move that a piece is allowed to do based on it's type
  // not to be confused with legal: valid and comply to the rules
  // (especially king's check), and many others
  List<Square> movesFrom(Square from) {
    final piece = pieceAt(from);
    if (piece == null) return [];
    switch (piece.type) {
      case .pawn: return _pawnMoves(from, piece.color);
      case .bishop: return _slidingMoves(from, Direction.diagonal, piece.color);
      case .rook: return _slidingMoves(from, Direction.straight, piece.color);
      case .knight: return _steppingMoves(from, KnightDirection.values, piece.color);
      case .queen: return _slidingMoves(from, Direction.values, piece.color);
      case .king: return _steppingMoves(from, Direction.values, piece.color);
    }
  }

  List<Square> _slidingMoves(Square from, List<Offset> direction, PieceColor moverColor) {
    final int rank = from.rank;
    final int file = from.file;

    List<Square> validMoves = [];

    for (final dir in direction) {
      int f = file + dir.dFile;
      int r = rank + dir.dRank;

      // while still in board
      rayLoop:
      while (Square(f, r).inBound) {
        final nextPosition = Square(f, r);
        final _SquareStatus status = _statusOfSquare(nextPosition, moverColor);
        switch (status) {
          case .ally || .offBoard:
            break rayLoop;
          case .enemy:
            validMoves.add(nextPosition);
            break rayLoop;
          case .empty:
            validMoves.add(nextPosition);
        }
        f += dir.dFile;
        r += dir.dRank;
      }
    }
    return validMoves;
  }

  List<Square> _steppingMoves(Square from, List<Offset> direction, PieceColor moverColor) {
    final int rank = from.rank;
    final int file = from.file;
    List<Square> validMoves = [];

    for (final dir in direction) {
      int f = file + dir.dFile;
      int r = rank + dir.dRank;

      // check in board
      final coor = Square(f, r);
      final _SquareStatus status = _statusOfSquare(coor, moverColor);
      switch (status) {
        case .enemy || .empty:
          validMoves.add(coor);
        case .ally || .offBoard:
          break;
      }
    }
    return validMoves;
  }

  List<Square> _pawnMoves(Square from, PieceColor moverColor) {
    final int file = from.file;
    final int rank = from.rank;

    List<Square> validMoves = [];
    final bool isPawnFromStartingPoint = (moverColor == .white && rank == 1) || (moverColor == .black && rank == 6);

    // black moves downward from white perspective
    final int dRank = moverColor == .black ? -1 : 1;

    // push forward
    final Square oneStep = Square(file, rank + dRank);
    if (_statusOfSquare(oneStep, moverColor) == .empty) {
      validMoves.add(oneStep);
      if (isPawnFromStartingPoint) {
        final Square twoStep = Square(file, rank + 2 * dRank);
        if (_statusOfSquare(twoStep, moverColor) == .empty) {
          validMoves.add(twoStep);
        }
      }
    }

    // capture enemy
    for (final dFile in [-1, 1]) {
      final coor = Square(file + dFile, rank + dRank);
      if (_statusOfSquare(coor, moverColor) == .enemy) {
        validMoves.add(coor);
      }
    }

    return validMoves;
  }

  _SquareStatus _statusOfSquare(Square square, PieceColor forColor) {
    if (!square.inBound) {
      return .offBoard;
    } else {
      final occupant = pieceAt(square);
      if (occupant == null) {
        return .empty;
      } else {
        if (occupant.color == forColor) {
          return .ally;
        } else {
          return .enemy;
        }
      }
    }
  }
}
