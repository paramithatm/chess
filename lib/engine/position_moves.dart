import 'package:chess/engine/castling.dart';
import 'package:chess/engine/direction.dart';
import 'package:chess/engine/move.dart';
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
      if (enPassantTarget == coor) {
        validMoves.add(coor);
      }
    }

    return validMoves;
  }

  // valid move + is king on check
  List<Square> legalMovesFrom(Square from) {
    final List<Square> legalMoves = [];
    final currentPieceColor = pieceAt(from)?.color;

    if (currentPieceColor == null) { return legalMoves; }

    for (final moveTo in movesFrom(from)) {
      final newPosition = applyMove(Move(from, moveTo));
      if (!newPosition.isChecked(currentPieceColor)) {
        legalMoves.add(moveTo);
      }
    }

    legalMoves.addAll(castlingMovesFrom(from));

    return legalMoves;
  }

  // MARK: Castling
  Square? castlingChecks(CastlingStatus side) {
    // if not allowed, don't castle
    if (!castlingRight.contains(side)) { return null; }

    // additional check for freely generated board
    // each color king should be on its home position
    if (pieceAt(side.color == .white ? .whiteKingOrigin : .blackKingOrigin) != Piece(side.color, .king)) { return null; }

    // check for rook in home square, especially if captured
    if (pieceAt(side.rookHomeSquare) != Piece(side.color, .rook)) { return null; }

    // castling rules: square in between must be empty & not under attack
    for (final sq in side.mustBeEmpty) {
      if (pieceAt(sq) != null) {
        return null;
      }
    }

    for (final sq in side.mustBeUnattacked) {
      if (isAttacked(sq, side.color.opposite)) {
        return null;
      }
    }

    // king must not be in check
    if (isChecked(side.color)) { return null; }

    return side.kingMoveTo;
  }

  List<Square> castlingMovesFrom(Square from) {
    final List<Square?> moves = [];
    final pieceToMove = pieceAt(from);

    if (pieceToMove == null) { return []; }


    if (pieceToMove.type == .king) {
      if (pieceToMove.color == .white) {
        final move = castlingRight
          .where((side) => side.color == .white)
          .map((side) => castlingChecks(side));
        moves.addAll(move);
      } else {
        final move = castlingRight
          .where((side) => side.color == .black)
          .map((side) => castlingChecks(side));
        moves.addAll(move);
      }
    }

    return moves.whereType<Square>().toList();
  }

  // MARK: Helper
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

  // MARK: Attack
  bool isAttacked(Square target, PieceColor attackerColor) {
    // TODO: pawn attacks empty square is not handled yet. (castling, en passant, etc)

    for (final squareToCheck in Square.allSquares) {
      final piece = pieceAt(squareToCheck);

      if (piece == null) {
        // there's no move coming from here, can skip
        continue;
      }

      if (attackerColor == piece.color) {
        if (movesFrom(squareToCheck).contains(target)) {
          // if any move contains the square, it is attacked. (though we don't track who attacks rn)
          return true;
        }
      }
    }
    return false;
  }

  Square findKing(PieceColor color) {
    for (final square in Square.allSquares) {
      if (pieceAt(square) == Piece(color, .king)) {
        return square;
      }
    }

    throw StateError("🚨 Error: ${color.toString()} king not found in board");
  }

  bool isChecked(PieceColor kingColor) {
    final kingPosition = findKing(kingColor);

    // is king attacked?
    return isAttacked(kingPosition, kingColor.opposite);
  }
  
  bool _hasNoLegalMoves(PieceColor color) {
    bool noLegalMoves = true;
    for (final square in Square.allSquares) {
      // skip enemy pieces
      if (pieceAt(square)?.color != color) continue;

      if (legalMovesFrom(square).isNotEmpty) {
        // if there's even one that's not empty
        noLegalMoves = false;
        break;
      }
    }
    return noLegalMoves;
  }

  bool isCheckMate(PieceColor kingColor) {
    return isChecked(kingColor) && _hasNoLegalMoves(kingColor);
  }

  bool isStaleMate(PieceColor kingColor) {
    return !isChecked(kingColor) && _hasNoLegalMoves(kingColor);
  }

  // need to check which pieces are still in board
  // cases where it's insufficient:
  // King vs King
  // King + Bishop vs King
  // King + Knight vs King
  // King + Bishop vs King + Bishop, both bishops on the same colour
  bool isInsufficientMaterial() {
    // non king square-piece list
     final filtered = <({ Square at, Piece piece})>[
      for (final sq in Square.allSquares)
        // non king piece
        if (pieceAt(sq) case final piece? when piece.type != .king) // piece? -> null filter
          (at: sq, piece: piece),
    ];
    
    // only king, draw
    if (filtered.isEmpty) {
      return true;
    }
    else if (filtered.length == 1) {
      final pieceType = filtered.first.piece.type;
      // Kkb / Kkn
      if (pieceType == .knight || pieceType == .bishop) { return true; }
    } else if (filtered.every((i) => i.piece.type == .bishop)) {
      // all bishop
      final tileColor = (filtered.first.at.file + filtered.first.at.rank) % 2;
      // all same colored
      if (filtered.every((i) => (i.at.file + i.at.rank) % 2 == tileColor)) {
        return true;
      }
    }
    
    return false;
  }

  bool isFiftyMove() {
    return false;
  }
}
