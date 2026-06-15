import 'package:chess/engine/direction.dart';
import 'package:chess/engine/piece.dart';
import 'package:chess/engine/square.dart';

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
    switch (pieceAt(from)?.type) {
      case .pawn: return _pawnMovesFrom(from);
      case .bishop: return _slidingMoves(from, Direction.diagonal);
      case .rook: return _slidingMoves(from, Direction.straight);
      case .knight: return _knightMovesFrom(from);
      case .queen: return _slidingMoves(from, Direction.values);
      case .king: return _kingMovesFrom(from);
      case null: return [];
    }
  }

  List<Square> _slidingMoves(Square from, List<Direction> direction) {
    final piece = pieceAt(from);
    final int rank = from.rank;
    final int file = from.file;

    List<Square> validMoves = [];

    for (final dir in direction) {
      int f = file + dir.dFile;
      int r = rank + dir.dRank;

      // while still in board
      while (f >= 0 && f <= 7 && r >= 0 && r <= 7) {
        final nextPosition = Square(f, r);
        final occupant = pieceAt(nextPosition);
        if (occupant == null) {
          // empty, can continue
          validMoves.add(nextPosition);
        } else {
          if (occupant.color == piece?.color) {
            // ally, stop
            break;
          } else {
            // enemy, capture
            validMoves.add(nextPosition);
            break;
          }
        }
        f += dir.dFile;
        r += dir.dRank;
      }
    }
    return validMoves;
  }

  List<Square> _knightMovesFrom(Square from) {
    
  }

  List<Square> _kingMovesFrom(Square from) {
    return []; 
  }

  List<Square> _pawnMovesFrom(Square from) {
    return []; 
  }
}