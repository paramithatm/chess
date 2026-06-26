import 'package:chess/engine/move.dart';
import 'package:chess/engine/piece.dart';
import 'package:chess/engine/position.dart';
import 'package:chess/engine/square.dart';
import 'package:test/test.dart';

void main() {
  group('initial position', () {
    test('pieces position should be set correctly', () {
      final pos = Position.initial();
      expect(pos.pieceAt(Square(3, 4)), null);
      // white king at E1
      expect(pos.pieceAt(Square(4, 0)), Piece(.white, .king));
      // black king at E8
      expect(pos.pieceAt(Square(4, 7)), Piece(.black, .king));

      expect(pos.pieceAt(Square(1, 7)), Piece(.black, .knight));
      expect(pos.pieceAt(Square(2, 7)), Piece(.black, .bishop));
      expect(pos.pieceAt(Square(3, 7)), Piece(.black, .queen));
      expect(pos.pieceAt(Square(3, 0)), Piece(.white, .queen));
      expect(pos.pieceAt(Square(2, 1)), Piece(.white, .pawn));
      expect(pos.pieceAt(Square(0, 0)), Piece(.white, .rook));
    });
  });

  // test movesFrom()
  group('valid rook moves', () {
    test('black rook from bottom right corner on an empty board', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.black, .rook),
      }, sideToMove: .black);
      expect(
        position.movesFrom(Square(0, 0)),
        unorderedEquals([
          Square(0, 1),
          Square(0, 2),
          Square(0, 3),
          Square(0, 4),
          Square(0, 5),
          Square(0, 6),
          Square(0, 7),
          Square(1, 0),
          Square(2, 0),
          Square(3, 0),
          Square(4, 0),
          Square(5, 0),
          Square(6, 0),
          Square(7, 0),
        ]),
      );
    });

    test('white rook from center on an empty board', () {
      final position = Position.fromPieces({
        Square(4, 3): Piece(.white, .rook),
      });
      expect(
        position.movesFrom(Square(4, 3)),
        unorderedEquals([
          Square(4, 0),
          Square(4, 1),
          Square(4, 2),
          Square(4, 4),
          Square(4, 5),
          Square(4, 6),
          Square(4, 7),
          Square(0, 3),
          Square(1, 3),
          Square(2, 3),
          Square(3, 3),
          Square(5, 3),
          Square(6, 3),
          Square(7, 3),
        ]),
      );
    });

    test('from initial position', () {
      final board = Position.initial();
      // no valid moves because rook in corner blocked by ally
      expect(board.movesFrom(Square(0, 0)), []);
    });

    test('at some side blocked by ally', () {
      final position = Position.fromPieces({
        Square(3, 2): Piece(.white, .rook),
        Square(5, 2): Piece(.white, .knight),
        Square(3, 6): Piece(.white, .queen),
      });

      expect(
        position.movesFrom(Square(3, 2)),
        unorderedEquals([
          Square(3, 0),
          Square(3, 1),
          Square(3, 3),
          Square(3, 4),
          Square(3, 5),
          Square(0, 2),
          Square(1, 2),
          Square(2, 2),
          Square(4, 2),
        ]),
      );
    });

    test('black captures enemy', () {
      final position = Position.fromPieces({
        Square(4, 6): Piece(.black, .rook),
        Square(4, 1): Piece(.white, .bishop),
      }, sideToMove: .black);

      expect(
        position.movesFrom(Square(4, 6)),
        unorderedEquals([
          Square(4, 1),
          Square(4, 2),
          Square(4, 3),
          Square(4, 4),
          Square(4, 5),
          Square(4, 7),
          Square(0, 6),
          Square(1, 6),
          Square(2, 6),
          Square(3, 6),
          Square(5, 6),
          Square(6, 6),
          Square(7, 6),
        ]),
      );
    });

    test('blocked by ally and can captures enemy', () {
      final position = Position.fromPieces({
        Square(6, 5): Piece(.white, .rook),
        Square(6, 2): Piece(.black, .bishop),
        Square(2, 5): Piece(.white, .bishop),
      }, sideToMove: .white);

      expect(
        position.movesFrom(Square(6, 5)),
        unorderedEquals([
          Square(6, 2),
          Square(6, 3),
          Square(6, 4),
          Square(6, 6),
          Square(6, 7),
          Square(3, 5),
          Square(4, 5),
          Square(5, 5),
          Square(7, 5),
        ]),
      );
    });
  });

  group('valid bishop moves', () {
    test('black bishop from bottom right corner on an empty board', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.black, .bishop),
      }, sideToMove: .black);
      expect(
        position.movesFrom(Square(0, 0)),
        unorderedEquals([
          Square(1, 1),
          Square(2, 2),
          Square(3, 3),
          Square(4, 4),
          Square(5, 5),
          Square(6, 6),
          Square(7, 7),
        ]),
      );
    });

    test('white bishop from center on an empty board', () {
      final position = Position.fromPieces({
        Square(3, 4): Piece(.white, .bishop),
      });
      expect(position.movesFrom(Square(3, 4)), unorderedEquals([
        Square(2,3),
        Square(1,2),
        Square(0,1),
        Square(4,5),
        Square(5,6),
        Square(6,7),
        Square(4,3),
        Square(5,2),
        Square(6,1),
        Square(7,0),
        Square(2,5),
        Square(1,6),
        Square(0,7),
      ]));
    });

    test('from initial position', () {
      final board = Position.initial();
      expect(board.movesFrom(Square(0, 2)), []);
    });

    test('at some side blocked by ally', () {
      final position = Position.fromPieces({
        Square(4, 2): Piece(.white, .bishop),
        Square(6, 0): Piece(.white, .knight),
        Square(1, 5): Piece(.white, .queen),
      });

      expect(
        position.movesFrom(Square(4, 2)),
        unorderedEquals([
          Square(5, 3),
          Square(6, 4),
          Square(7, 5),
          Square(3, 1),
          Square(2, 0),
          Square(5, 1),
          Square(3, 3),
          Square(2, 4)
        ]),
      );
    });

    test('captures enemy', () {
      // black bishop on b7; white enemy on e4 sits on its down-right diagonal
      final position = Position.fromPieces({
        Square(1, 6): Piece(.black, .bishop),
        Square(4, 3): Piece(.white, .bishop),
      }, sideToMove: .black);

      expect(
        position.movesFrom(Square(1, 6)),
        unorderedEquals([
          Square(2, 5),
          Square(3, 4),
          Square(4, 3), // capture
          Square(2, 7),
          Square(0, 7),
          Square(0, 5),
        ]),
      );
    });

    test('blocked by ally and can capture enemy', () {
      final position = Position.fromPieces({
        Square(3, 3): Piece(.white, .bishop),
        Square(5, 5): Piece(.white, .knight),
        Square(1, 5): Piece(.black, .pawn),
      });

      expect(
        position.movesFrom(Square(3, 3)),
        unorderedEquals([
          Square(4, 4),
          Square(2, 4),
          Square(1, 5), // capture
          Square(4, 2),
          Square(5, 1),
          Square(6, 0),
          Square(2, 2),
          Square(1, 1),
          Square(0, 0),
        ]),
      );
    });
  });

  group('valid knight moves', () {
    test('white knight from center on an empty board', () {
      final position = Position.fromPieces({
        Square(3, 3): Piece(.white, .knight),
      });
      expect(
        position.movesFrom(Square(3, 3)),
        unorderedEquals([
          Square(4, 5),
          Square(2, 5),
          Square(5, 4),
          Square(1, 4),
          Square(5, 2),
          Square(1, 2),
          Square(4, 1),
          Square(2, 1),
        ]),
      );
    });

    test('from a corner has only two moves', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .knight),
      });
      expect(
        position.movesFrom(Square(0, 0)),
        unorderedEquals([
          Square(1, 2),
          Square(2, 1),
        ]),
      );
    });

    test('jumps over its own pawns from the initial position', () {
      final board = Position.initial();
      // white knight on b1 hops over the pawn wall on rank 2
      expect(
        board.movesFrom(Square(1, 0)),
        unorderedEquals([
          Square(0, 2),
          Square(2, 2),
        ]),
      );
    });

    test('blocked by ally and can capture enemy', () {
      final position = Position.fromPieces({
        Square(3, 3): Piece(.white, .knight),
        Square(4, 5): Piece(.white, .pawn), // ally blocks this landing square
        Square(5, 4): Piece(.black, .rook), // enemy can be captured
      });
      expect(
        position.movesFrom(Square(3, 3)),
        unorderedEquals([
          Square(2, 5),
          Square(5, 4), // capture
          Square(1, 4),
          Square(5, 2),
          Square(1, 2),
          Square(4, 1),
          Square(2, 1),
        ]),
      );
    });
  });

  group('valid king moves', () {
    test('white king from center on an empty board', () {
      final position = Position.fromPieces({
        Square(3, 3): Piece(.white, .king),
      });
      expect(
        position.movesFrom(Square(3, 3)),
        unorderedEquals([
          Square(4, 3),
          Square(2, 3),
          Square(3, 4),
          Square(3, 2),
          Square(4, 4),
          Square(4, 2),
          Square(2, 4),
          Square(2, 2),
        ]),
      );
    });

    test('from a corner has only three moves', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
      });
      expect(
        position.movesFrom(Square(0, 0)),
        unorderedEquals([
          Square(1, 0),
          Square(0, 1),
          Square(1, 1),
        ]),
      );
    });

    test('blocked by ally and can capture enemy', () {
      final position = Position.fromPieces({
        Square(3, 3): Piece(.white, .king),
        Square(4, 3): Piece(.white, .pawn), // ally blocks this step
        Square(2, 3): Piece(.black, .rook), // enemy can be captured
      });
      expect(
        position.movesFrom(Square(3, 3)),
        unorderedEquals([
          Square(2, 3), // capture
          Square(3, 4),
          Square(3, 2),
          Square(4, 4),
          Square(4, 2),
          Square(2, 4),
          Square(2, 2),
        ]),
      );
    });
  });

  group('valid pawn moves', () {
    // --- White: moves north (rank + 1), home rank is 1 ---

    test('white pawn on its home rank can step one or two', () {
      final position = Position.fromPieces({
        Square(4, 1): Piece(.white, .pawn),
      });
      expect(
        position.movesFrom(Square(4, 1)),
        unorderedEquals([
          Square(4, 2), // single
          Square(4, 3), // double
        ]),
      );
    });

    test('white pawn off its home rank steps only one', () {
      final position = Position.fromPieces({
        Square(4, 3): Piece(.white, .pawn),
      });
      expect(
        position.movesFrom(Square(4, 3)),
        unorderedEquals([
          Square(4, 4),
        ]),
      );
    });

    test('white pawn blocked directly ahead has no moves', () {
      // enemy sitting right in front cannot be captured forward
      final position = Position.fromPieces({
        Square(4, 1): Piece(.white, .pawn),
        Square(4, 2): Piece(.black, .pawn),
      });
      expect(position.movesFrom(Square(4, 1)), <Square>[]);
    });

    test('white pawn on home rank with the double-step square blocked steps only one', () {
      final position = Position.fromPieces({
        Square(4, 1): Piece(.white, .pawn),
        Square(4, 3): Piece(.white, .knight), // blocks the two-square jump
      });
      expect(
        position.movesFrom(Square(4, 1)),
        unorderedEquals([
          Square(4, 2),
        ]),
      );
    });

    test('white pawn captures an enemy on its diagonal', () {
      final position = Position.fromPieces({
        Square(4, 3): Piece(.white, .pawn),
        Square(5, 4): Piece(.black, .bishop), // up-right diagonal
      });
      expect(
        position.movesFrom(Square(4, 3)),
        unorderedEquals([
          Square(4, 4), // forward
          Square(5, 4), // capture
        ]),
      );
    });

    test('white pawn cannot capture an ally but can capture an enemy', () {
      final position = Position.fromPieces({
        Square(4, 3): Piece(.white, .pawn),
        Square(5, 4): Piece(.white, .rook), // ally on one diagonal: not a move
        Square(3, 4): Piece(.black, .rook), // enemy on the other: capture
      });
      expect(
        position.movesFrom(Square(4, 3)),
        unorderedEquals([
          Square(4, 4), // forward
          Square(3, 4), // capture
        ]),
      );
    });

    test('white pawn on the a-file has only the one in-board diagonal', () {
      // the off-board left diagonal must not appear (and must not crash)
      final position = Position.fromPieces({
        Square(0, 3): Piece(.white, .pawn),
        Square(1, 4): Piece(.black, .knight),
      });
      expect(
        position.movesFrom(Square(0, 3)),
        unorderedEquals([
          Square(0, 4), // forward
          Square(1, 4), // capture
        ]),
      );
    });

    // --- Black: moves south (rank - 1), home rank is 6 ---

    test('black pawn on its home rank can step one or two', () {
      final position = Position.fromPieces({
        Square(4, 6): Piece(.black, .pawn),
      }, sideToMove: .black);
      expect(
        position.movesFrom(Square(4, 6)),
        unorderedEquals([
          Square(4, 5), // single
          Square(4, 4), // double
        ]),
      );
    });

    test('black pawn captures an enemy on its (downward) diagonal', () {
      final position = Position.fromPieces({
        Square(4, 5): Piece(.black, .pawn),
        Square(3, 4): Piece(.white, .bishop), // down-left diagonal
      }, sideToMove: .black);
      expect(
        position.movesFrom(Square(4, 5)),
        unorderedEquals([
          Square(4, 4), // forward (south)
          Square(3, 4), // capture
        ]),
      );
    });

    test('black pawn blocked directly ahead has no moves', () {
      final position = Position.fromPieces({
        Square(4, 6): Piece(.black, .pawn),
        Square(4, 5): Piece(.white, .pawn),
      }, sideToMove: .black);
      expect(position.movesFrom(Square(4, 6)), <Square>[]);
    });
  });

  group('valid queen moves', () {
    test('white queen from center on an empty board', () {
      final position = Position.fromPieces({
        Square(3, 3): Piece(.white, .queen),
      });
      expect(
        position.movesFrom(Square(3, 3)),
        unorderedEquals([
          // straight rays
          Square(4, 3),
          Square(5, 3),
          Square(6, 3),
          Square(7, 3),
          Square(2, 3),
          Square(1, 3),
          Square(0, 3),
          Square(3, 4),
          Square(3, 5),
          Square(3, 6),
          Square(3, 7),
          Square(3, 2),
          Square(3, 1),
          Square(3, 0),
          // diagonal rays
          Square(4, 4),
          Square(5, 5),
          Square(6, 6),
          Square(7, 7),
          Square(4, 2),
          Square(5, 1),
          Square(6, 0),
          Square(2, 4),
          Square(1, 5),
          Square(0, 6),
          Square(2, 2),
          Square(1, 1),
          Square(0, 0),
        ]),
      );
    });

    test('from initial position', () {
      final board = Position.initial();
      // queen on d1 is hemmed in by her own pieces
      expect(board.movesFrom(Square(3, 0)), []);
    });

    test('blocked by ally and can capture enemy', () {
      final position = Position.fromPieces({
        Square(3, 3): Piece(.white, .queen),
        Square(3, 5): Piece(.white, .pawn),
        Square(1, 1): Piece(.white, .knight),
        Square(5, 3): Piece(.black, .rook),
      });

      expect(
        position.movesFrom(Square(3, 3)),
        unorderedEquals([
          Square(4, 3),
          Square(5, 3), // capture
          Square(2, 3),
          Square(1, 3),
          Square(0, 3),
          Square(3, 4),
          Square(3, 2),
          Square(3, 1),
          Square(3, 0),
          Square(4, 4),
          Square(5, 5),
          Square(6, 6),
          Square(7, 7),
          Square(4, 2),
          Square(5, 1),
          Square(6, 0),
          Square(2, 4),
          Square(1, 5),
          Square(0, 6),
          Square(2, 2),
        ]),
      );
    });
  });

  group('applyMove', () {
    test('moves the piece and flips the turn', () {
      final before = Position.fromPieces({
        Square(4, 1): Piece(.white, .pawn),
      });
      final after = before.applyMove(Move(Square(4, 1), Square(4, 3)));

      expect(after.pieceAt(Square(4, 1)), null);                 // from cleared
      expect(after.pieceAt(Square(4, 3)), Piece(.white, .pawn)); // to filled
      expect(after.sideToMove, PieceColor.black);                // turn flipped
    });

    test('does not mutate the original position', () {
      final before = Position.fromPieces({
        Square(4, 1): Piece(.white, .pawn),
      });

      before.applyMove(Move(Square(4, 1), Square(4, 3))); // apply, ignore the result

      // the original snapshot must be untouched (this is what the deep copy buys us)
      expect(before.pieceAt(Square(4, 1)), Piece(.white, .pawn)); // pawn still home
      expect(before.pieceAt(Square(4, 3)), null);                 // never moved
      expect(before.sideToMove, PieceColor.white);                // still white's turn
    });

    test('a capture replaces the enemy piece', () {
      final before = Position.fromPieces({
        Square(4, 3): Piece(.white, .rook),
        Square(4, 6): Piece(.black, .pawn),
      });
      final after = before.applyMove(Move(Square(4, 3), Square(4, 6)));

      expect(after.pieceAt(Square(4, 6)), Piece(.white, .rook)); // rook took the square
      expect(after.pieceAt(Square(4, 3)), null);

      // and the captured piece is still recoverable from the before-snapshot
      expect(before.pieceAt(Square(4, 6)), Piece(.black, .pawn));
    });
  });
}
