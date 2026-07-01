import 'package:chess/engine/castling.dart';
import 'package:chess/engine/move.dart';
import 'package:chess/engine/piece.dart';
import 'package:chess/engine/square.dart';

// Move generation is defined as an extension in position_moves.dart; re-export
// it so anything importing position.dart still gets movesFrom().
export 'package:chess/engine/position_moves.dart';

// in chess it's called position; actually a board state of current position
// basically the game state at any given time
// immutable, we create new position everytime instead -> undo / redo / calculate moves
class Position {
  final List<List<Piece?>> _board;
  final PieceColor sideToMove;

  // special moves
  final Set<CastlingStatus> castlingRight;
  final Square? enPassantTarget;

  // check what's on coordinate square. also flip the file-rank coordinate system for board to read
  Piece? pieceAt(Square square) => _board[square.rank][square.file];

  static void _put(List<List<Piece?>> board, Piece? piece, Square square) {
    board[square.rank][square.file] = piece;
  }

  // grid with no piece
  static List<List<Piece?>> get _emptyBoard => List.generate(8, (_) => List<Piece?>.filled(8, null));

  // draw position from piece list. flip the file-rank from square to draw board.
  factory Position.fromPieces(Map<Square, Piece> pieces, { PieceColor sideToMove = PieceColor.white, List<CastlingStatus> castlingRight = CastlingStatus.values, Square? enPassantTarget }) {
    final board = _emptyBoard;
    pieces.forEach((square, piece) => _put(board, piece, square));
    return Position(board, sideToMove, castlingRight.toSet(), enPassantTarget);
  }

  Position(this._board, this.sideToMove, this.castlingRight, this.enPassantTarget);

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

    final Set<CastlingStatus> castlingRight = CastlingStatus.values.toSet();

    // game always start with white
    return Position(board, .white, castlingRight, null);
  }

  // helper to print board state
  @override
  String toString() {
    final row = StringBuffer();
    for (final square in Square.allSquares) {
      Piece? piece = pieceAt(square);
      row.write(piece ?? ' ');
    }
    row.write('\n');

    return row.toString();
  }

  // move piece from -> to, without the chess rules
  static void _movePiece(List<List<Piece?>> board, Piece? piece, Move move) {
    // clear from prev position
    _put(board, null, move.from);
    // put piece to new position
    _put(board, piece, move.to);
  }

  // Apply a (legal) move and return the resulting position. Immutable: the new
  // board is a deep copy, so `this` is never touched. Reads as a sequence of
  // named steps; each special-move rule lives in its own helper below.
  Position applyMove(Move move) {
    final newBoard = [for (final row in _board) [...row]];
    final mover = pieceAt(move.from);

    // nothing to move — hand back an untouched copy
    if (mover == null) {
      return Position(newBoard, sideToMove, castlingRight.toSet(), null);
    }

    _movePiece(newBoard, mover, move);
    _castleRookHop(newBoard, move, mover);
    _removeEnPassantCapture(newBoard, move, mover);
    _applyPromotion(newBoard, move, mover);

    return Position(
      newBoard,
      sideToMove.opposite,
      _nextCastlingRights(move, mover),
      _nextEnPassantTarget(move, mover),
    );
  }

  // The castling rights that survive this move: a king move drops both of its
  // colour's; a rook leaving a1/h1 (a8/h8) drops that side's.
  Set<CastlingStatus> _nextCastlingRights(Move move, Piece mover) {
    final rights = castlingRight.toSet();

    if (mover.type == .king) {
      if (mover.color == .white) {
        rights.remove(CastlingStatus.whiteKingSide);
        rights.remove(CastlingStatus.whiteQueenSide);
      } else {
        rights.remove(CastlingStatus.blackKingSide);
        rights.remove(CastlingStatus.blackQueenSide);
      }
    } else if (mover.type == .rook) {
      if (move.from.file == 0) {
        rights.remove(mover.color == .white ? CastlingStatus.whiteQueenSide : CastlingStatus.blackQueenSide);
      } else if (move.from.file == 7) {
        rights.remove(mover.color == .white ? CastlingStatus.whiteKingSide : CastlingStatus.blackKingSide);
      }
    }

    return rights;
  }

  // A king moving two files is a castle; slide the matching rook across too.
  void _castleRookHop(List<List<Piece?>> board, Move move, Piece mover) {
    if (mover.type != .king || (move.from.file - move.to.file).abs() != 2) return;
    final castle = CastlingStatus.values.firstWhere((c) => c.kingMoveTo == move.to);
    _movePiece(board, Piece(mover.color, .rook), castle.rookMoves);
  }

  // The en passant target this move creates: the square a double-stepping pawn
  // skipped over, else null.
  Square? _nextEnPassantTarget(Move move, Piece mover) {
    final isDoubleStep = mover.type == .pawn && (move.to.rank - move.from.rank).abs() == 2;
    if (!isDoubleStep) return null;
    final dRank = mover.color == .white ? -1 : 1;
    return Square(move.to.file, move.to.rank + dRank);
  }

  // If this move lands on the (incoming) en passant target, remove the captured
  // pawn — it sits beside the target, not on it.
  void _removeEnPassantCapture(List<List<Piece?>> board, Move move, Piece mover) {
    if (move.to != enPassantTarget) return;
    final dRank = mover.color == .white ? -1 : 1;
    _put(board, null, Square(move.to.file, move.to.rank + dRank));
  }

  // TODO(CHESS-4.6): a pawn reaching the last rank becomes move.promoteTo.
  // Placeholder for now — no-op, so ordinary moves are unaffected.
  void _applyPromotion(List<List<Piece?>> board, Move move, Piece mover) {
    // not implemented yet
  }
}
