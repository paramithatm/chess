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

  // Apply a legal move and return the resulting position
  // Immutable: the new board is a deep copy, so `this` is never touched
  // special-move rule lives in its own helper below
  Position applyMove(Move move) {
    final newBoard = [for (final row in _board) [...row]];
    final movingPiece = pieceAt(move.from);

    // nothing to move — return untouched copy
    if (movingPiece == null) {
      return Position(newBoard, sideToMove, castlingRight.toSet(), null);
    }

    _movePiece(newBoard, movingPiece, move);
    _moveCastlingRook(newBoard, move, movingPiece);
    _removeEnPassantCapture(newBoard, move, movingPiece);
    _applyPromotion(newBoard, move, movingPiece);

    return Position(
      newBoard,
      sideToMove.opposite,
      _nextCastlingRights(move, movingPiece),
      _nextEnPassantTarget(move, movingPiece),
    );
  }

  // The castling rights that survive this move: a king move drops both of its
  // colour's; a rook leaving a1/h1 (a8/h8) drops that side's.
  Set<CastlingStatus> _nextCastlingRights(Move move, Piece movingPiece) {
    final rights = castlingRight.toSet();

    if (movingPiece.type == .king) {
      if (movingPiece.color == .white) {
        rights.removeAll([CastlingStatus.whiteKingSide, CastlingStatus.whiteQueenSide]);
      } else {
        rights.removeAll([CastlingStatus.blackKingSide, CastlingStatus.blackQueenSide]);
      }
    } else if (movingPiece.type == .rook) {
      if (move.from.file == 0) {
        rights.remove(movingPiece.color == .white ? CastlingStatus.whiteQueenSide : CastlingStatus.blackQueenSide);
      } else if (move.from.file == 7) {
        rights.remove(movingPiece.color == .white ? CastlingStatus.whiteKingSide : CastlingStatus.blackKingSide);
      }
    }

    return rights;
  }

  // A king moving two files is a castle. Move the matching rook too
  void _moveCastlingRook(List<List<Piece?>> board, Move move, Piece movingPiece) {
    if (movingPiece.type != .king || (move.from.file - move.to.file).abs() != 2) return;
    final castle = CastlingStatus.values.firstWhere((c) => c.kingMoveTo == move.to);
    _movePiece(board, Piece(movingPiece.color, .rook), castle.rookMoves);
  }

  // After double step, enemy can en passant. otherwise, make it null (not allowed)
  Square? _nextEnPassantTarget(Move move, Piece movingPiece) {
    final isDoubleStep = movingPiece.type == .pawn && (move.to.rank - move.from.rank).abs() == 2;
    if (!isDoubleStep) return null;
    final dRank = movingPiece.color == .white ? -1 : 1;
    return Square(move.to.file, move.to.rank + dRank);
  }

  // If the move lands on en passant target, remove the captured pawn
  void _removeEnPassantCapture(List<List<Piece?>> board, Move move, Piece movingPiece) {
    if (move.to != enPassantTarget) return;
    final dRank = movingPiece.color == .white ? -1 : 1;
    _put(board, null, Square(move.to.file, move.to.rank + dRank));
  }

  // pawn at max rank should promote
  void _applyPromotion(List<List<Piece?>> board, Move move, Piece movingPiece) {
    final promoteTo = move.promoteTo;
    if (promoteTo == null) { return; }
    if (movingPiece.type != .pawn) { return; }
    if (movingPiece.color == .white && move.to.rank != 7) { return; }
    if (movingPiece.color == .black && move.to.rank != 0) { return; }

    _put(board, Piece(movingPiece.color, promoteTo), move.to);
  }
}
