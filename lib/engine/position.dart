import 'package:chess/engine/direction.dart';
import 'package:chess/engine/piece.dart';
import 'package:chess/engine/square.dart';

// status of square x, depending on position and whose turn is it
enum _SquareStatus {
    empty,
    ally,
    enemy,
    offBoard;
  }

// in chess it's called position; actually a board of what's current position
// basically the game state at any given time
// immutable, we create new position everytime instead -> undo / redo / calculate moves
class Position {
  final List<List<Piece?>> _board;
  final PieceColor sideToMove;

  // check what's on coordinate square. also flip the file-rank coordinate system for board to read
  Piece? pieceAt(Square square) => _board[square.rank][square.file];

  // grid with no piece
  static List<List<Piece?>> get _emptyBoard => List.generate(8, (_) => List<Piece?>.filled(8, null));

  // draw position from piece list. flip the file-rank from square to draw board.
  factory Position.fromPieces(Map<Square, Piece> pieces, { PieceColor sideToMove = PieceColor.white }) {
    final board = _emptyBoard;
    pieces.forEach((square, piece) => board[square.rank][square.file] = piece);
    return Position(board, sideToMove);
  }

  Position(this._board, this.sideToMove);

  // named constructor
  factory Position.initial() {
    final board = _emptyBoard;
    // MARK: - empty board + starting piece
    initialRow(PieceColor color) => [
        Piece(color, .rook),
        Piece(color, .knight),
        Piece(color, .bishop),
        Piece(color, .queen),
        Piece(color, .king),
        Piece(color, .bishop),
        Piece(color, .knight),
        Piece(color, .rook)
      ];

    board[0] = initialRow(.white);
    board[1] = List.generate(8, (_) => Piece(.white, .pawn));
    board[6] = List.generate(8, (_) => Piece(.black, .pawn));
    board[7] = initialRow(.black);

    // game always start with white
    return Position(board, .white);
  }

  // helper to print board state
  @override
  String toString() {
    final row = StringBuffer();
    for (int i = 7; i >= 0; i--) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = pieceAt(Square(j, i));
        row.write(piece ?? ' ');
      }
      row.write('\n');
    }

    return row.toString();
  }

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
        final _SquareStatus status = statusOfSquare(nextPosition, moverColor);
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
      final _SquareStatus status = statusOfSquare(coor, moverColor);
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
    if (statusOfSquare(oneStep, moverColor) == .empty) {
      validMoves.add(oneStep);
      if (isPawnFromStartingPoint) {
        final Square twoStep = Square(file, rank + 2 * dRank);
        if (statusOfSquare(twoStep, moverColor) == .empty) {
          validMoves.add(twoStep);
        }
      }
    }

    // capture enemy
    for (final dFile in [-1, 1]) {
      final coor = Square(file + dFile, rank + dRank);
      if (statusOfSquare(coor, moverColor) == .enemy) {
        validMoves.add(coor);
      }
    }
    
    return validMoves;
  }

  _SquareStatus statusOfSquare(Square square, PieceColor forColor) {
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

