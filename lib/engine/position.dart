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

  // check what's on coordinate square. also flip the file-rank coordinate system for board to read
  Piece? pieceAt(Square square) => _board[square.rank][square.file];

  static void _put(List<List<Piece?>> board, Piece? piece, Square square) {
    board[square.rank][square.file] = piece;
  }

  // grid with no piece
  static List<List<Piece?>> get _emptyBoard => List.generate(8, (_) => List<Piece?>.filled(8, null));

  // draw position from piece list. flip the file-rank from square to draw board.
  factory Position.fromPieces(Map<Square, Piece> pieces, { PieceColor sideToMove = PieceColor.white }) {
    final board = _emptyBoard;
    pieces.forEach((square, piece) => _put(board, piece, square));
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

  Position applyMove(Move move) {
    final newBoard = [for (final row in _board) [...row]];
    final pieceToMove = pieceAt(move.from);
    // clear from prev position
    _put(newBoard, null, move.from);
    // put piece to new position
    _put(newBoard, pieceToMove, move.to);
    // flip turn
    return Position(newBoard, sideToMove.opposite);
  }
}
