import 'package:chess/engine/castling.dart';
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

      expect(after.pieceAt(Square(4, 1)), null); // from cleared
      expect(after.pieceAt(Square(4, 3)), Piece(.white, .pawn)); // to filled
      expect(after.sideToMove, PieceColor.black); // turn flipped
    });

    test('does not mutate the original position', () {
      final before = Position.fromPieces({
        Square(4, 1): Piece(.white, .pawn),
      });

      before.applyMove(Move(Square(4, 1), Square(4, 3))); // apply, ignore the result

      // the original snapshot must be untouched
      expect(before.pieceAt(Square(4, 1)), Piece(.white, .pawn)); // pawn still home
      expect(before.pieceAt(Square(4, 3)), null); // never moved
      expect(before.sideToMove, PieceColor.white); // still white's turn
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

  group('isAttacked', () {
    test('rook attacks along its file and rank, including empty squares', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .rook),
      });
      expect(position.isAttacked(Square(0, 5), .white), true);  // up the file (empty)
      expect(position.isAttacked(Square(5, 0), .white), true);  // along the rank (empty)
      expect(position.isAttacked(Square(3, 3), .white), false); // off its lines
    });

    test('only counts attackers of the asked color', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .rook),
      });
      expect(position.isAttacked(Square(0, 5), .white), true);
      expect(position.isAttacked(Square(0, 5), .black), false); // no black attacker
    });

    test('a blocker stops a rook from attacking past it', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .rook),
        Square(0, 3): Piece(.white, .pawn), // blocks the file
      });
      expect(position.isAttacked(Square(0, 5), .white), false); // beyond the blocker
    });

    test('knight attacks its L-squares', () {
      final position = Position.fromPieces({
        Square(3, 3): Piece(.white, .knight),
      });
      expect(position.isAttacked(Square(4, 5), .white), true);  // an L-jump
      expect(position.isAttacked(Square(3, 4), .white), false); // adjacent, not an L
    });

    test('king attacks adjacent squares only', () {
      final position = Position.fromPieces({
        Square(4, 4): Piece(.white, .king),
      });
      expect(position.isAttacked(Square(4, 5), .white), true);  // next to it
      expect(position.isAttacked(Square(4, 6), .white), false); // two away
    });

    test('pawn attacks an enemy on its diagonal', () {
      // the case check-detection relies on: an enemy sits on the diagonal.
      // (empty-diagonal pawn attacks are the known TODO, not tested here.)
      final position = Position.fromPieces({
        Square(4, 3): Piece(.white, .pawn),
        Square(5, 4): Piece(.black, .king),
      });
      expect(position.isAttacked(Square(5, 4), .white), true);
    });
  });

  group('isChecked', () {
    test('rook checks the king down an open file', () {
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(4, 7): Piece(.black, .rook), // same file, clear path
      });
      expect(position.isChecked(.white), true);
    });

    test('a blocker between rook and king means no check', () {
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(4, 7): Piece(.black, .rook),
        Square(4, 3): Piece(.white, .pawn), // blocks the rook's path
      });
      expect(position.isChecked(.white), false);
    });

    test('knight checks the king (cannot be blocked)', () {
      final position = Position.fromPieces({
        Square(4, 4): Piece(.white, .king),
        Square(5, 6): Piece(.black, .knight), // an L away from the king
      });
      expect(position.isChecked(.white), true);
    });

    test('pawn checks the king on its diagonal', () {
      final position = Position.fromPieces({
        Square(4, 4): Piece(.white, .king),
        Square(5, 5): Piece(.black, .pawn), // black pawn attacks down-left to (4,4)
      });
      expect(position.isChecked(.white), true);
    });

    test('black king can be in check too', () {
      final position = Position.fromPieces({
        Square(4, 7): Piece(.black, .king),
        Square(4, 0): Piece(.white, .queen), // up the open file
      }, sideToMove: .black);
      expect(position.isChecked(.black), true);
    });

    test('initial position: neither king is in check', () {
      final position = Position.initial();
      expect(position.isChecked(.white), false);
      expect(position.isChecked(.black), false);
    });

    test('king alone with a distant enemy is not in check', () {
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(5, 7): Piece(.black, .rook), // different file and rank
      });
      expect(position.isChecked(.white), false);
    });

    test('bishop checks the king along a diagonal', () {
      final position = Position.fromPieces({
        Square(4, 4): Piece(.white, .king),
        Square(7, 7): Piece(.black, .bishop), // up-right diagonal, clear path
      });
      expect(position.isChecked(.white), true);
    });

    test('a blocker on the diagonal stops the bishop check', () {
      final position = Position.fromPieces({
        Square(4, 4): Piece(.white, .king),
        Square(7, 7): Piece(.black, .bishop),
        Square(6, 6): Piece(.white, .pawn), // blocks the diagonal
      });
      expect(position.isChecked(.white), false);
    });

    test('queen checks along a diagonal like a bishop', () {
      final position = Position.fromPieces({
        Square(4, 4): Piece(.white, .king),
        Square(1, 1): Piece(.black, .queen), // down-left diagonal, clear path
      });
      expect(position.isChecked(.white), true);
    });
  });

  group('legalMovesFrom', () {
    test('a pinned rook may only move along the pin line', () {
      // white rook is pinned to its king by the black rook on the e-file;
      // sideways moves would expose the king, so only file moves survive.
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(4, 3): Piece(.white, .rook),
        Square(4, 7): Piece(.black, .rook),
      });
      expect(
        position.legalMovesFrom(Square(4, 3)),
        unorderedEquals([
          Square(4, 4),
          Square(4, 5),
          Square(4, 6),
          Square(4, 7), // capture the pinner
          Square(4, 2),
          Square(4, 1),
        ]),
      );
    });

    test('a king in check must step off the attacked line', () {
      // black rook checks down the e-file; the king cannot stay on file 4.
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(4, 7): Piece(.black, .rook),
      });
      expect(
        position.legalMovesFrom(Square(4, 0)),
        unorderedEquals([
          Square(3, 0),
          Square(5, 0),
          Square(3, 1),
          Square(5, 1),
          // Square(4, 1) is NOT legal — still on the checked file
        ]),
      );
    });

    test('only a move that blocks the check is legal', () {
      // king in check from the rook; the bishop's one legal move is to
      // interpose on the e-file. Every other bishop move leaves the king in check.
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(4, 7): Piece(.black, .rook),
        Square(2, 2): Piece(.white, .bishop),
      });
      expect(
        position.legalMovesFrom(Square(2, 2)),
        unorderedEquals([
          Square(4, 4), // the only interposing square
        ]),
      );
    });

    test('king may not step into an attacked square (not currently in check)', () {
      // black rook controls rank 5; the king (on rank 4) is safe now,
      // but may not walk onto rank 5.
      final position = Position.fromPieces({
        Square(4, 4): Piece(.white, .king),
        Square(7, 5): Piece(.black, .rook),
      });
      expect(
        position.legalMovesFrom(Square(4, 4)),
        unorderedEquals([
          Square(3, 4),
          Square(5, 4),
          Square(3, 3),
          Square(4, 3),
          Square(5, 3),
          // rank-5 squares (3,5) (4,5) (5,5) are all attacked → filtered
        ]),
      );
    });

    test('a free piece keeps all its moves when the king is safe', () {
      // no enemies, king tucked away → nothing gets filtered.
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(4, 4): Piece(.white, .knight),
      });
      expect(
        position.legalMovesFrom(Square(4, 4)),
        unorderedEquals([
          Square(5, 6),
          Square(3, 6),
          Square(6, 5),
          Square(2, 5),
          Square(6, 3),
          Square(2, 3),
          Square(5, 2),
          Square(3, 2),
        ]),
      );
    });
  });

  group('isCheckMate', () {
    test('back-rank mate is checkmate', () {
      // black king boxed in by its own pawns; white rook mates along the 8th rank.
      final position = Position.fromPieces({
        Square(0, 7): Piece(.black, .king), // a8
        Square(0, 6): Piece(.black, .pawn), // a7  (blocks escape)
        Square(1, 6): Piece(.black, .pawn), // b7  (blocks escape)
        Square(7, 7): Piece(.white, .rook), // h8  (delivers mate)
      }, sideToMove: .black);
      expect(position.isCheckMate(.black), true);
    });

    test('check the king can escape is not checkmate', () {
      // rook checks down the file, but the king has empty squares to flee to.
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(4, 7): Piece(.black, .rook),
      });
      expect(position.isCheckMate(.white), false);
    });

    test('initial position is not checkmate', () {
      expect(Position.initial().isCheckMate(.white), false);
    });

    test('a check that can be blocked is not checkmate', () {
      // rook checks the king, but the bishop can interpose on the e-file.
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(4, 7): Piece(.black, .rook),
        Square(2, 2): Piece(.white, .bishop), // can block at (4,4)
      });
      expect(position.isCheckMate(.white), false);
    });
  });

  group('isStaleMate', () {
    test('king not in check but with no legal move is stalemate', () {
      // black king on a8; white queen on b6 covers a7, b7, b8 — but NOT a8,
      // so the king is not in check, yet has nowhere to go.
      final position = Position.fromPieces({
        Square(0, 7): Piece(.black, .king),  // a8
        Square(1, 5): Piece(.white, .queen), // b6
      }, sideToMove: .black);
      expect(position.isStaleMate(.black), true);
    });

    test('a king with legal moves is not stalemate', () {
      // not in check and free to roam.
      final position = Position.fromPieces({
        Square(4, 4): Piece(.black, .king),
        Square(0, 0): Piece(.white, .rook), // far away, controls only rank 0 / file 0
      }, sideToMove: .black);
      expect(position.isStaleMate(.black), false);
    });

    test('checkmate is not stalemate', () {
      // same back-rank position as the mate test: no legal moves, but the king
      // IS in check — that is checkmate, so stalemate must be false.
      final position = Position.fromPieces({
        Square(0, 7): Piece(.black, .king),
        Square(0, 6): Piece(.black, .pawn),
        Square(1, 6): Piece(.black, .pawn),
        Square(7, 7): Piece(.white, .rook),
      }, sideToMove: .black);
      expect(position.isStaleMate(.black), false);
    });

    test('initial position is not stalemate', () {
      expect(Position.initial().isStaleMate(.white), false);
    });
  });

  group('castling rights tracking', () {
    // these assume fromPieces starts a position with all four rights.

    test('moving the king drops both of its colors rights', () {
      final before = Position.fromPieces({Square(4, 0): Piece(.white, .king)});
      final after = before.applyMove(Move(Square(4, 0), Square(4, 1)));

      expect(after.castlingRight.contains(CastlingStatus.whiteKingSide), false);
      expect(after.castlingRight.contains(CastlingStatus.whiteQueenSide), false);
      // black's rights are untouched
      expect(after.castlingRight.contains(CastlingStatus.blackKingSide), true);
      expect(after.castlingRight.contains(CastlingStatus.blackQueenSide), true);
    });

    test('moving the a-file rook drops only that colors queenside right', () {
      final before = Position.fromPieces({Square(0, 0): Piece(.white, .rook)});
      final after = before.applyMove(Move(Square(0, 0), Square(0, 1)));

      expect(after.castlingRight.contains(CastlingStatus.whiteQueenSide), false);
      expect(after.castlingRight.contains(CastlingStatus.whiteKingSide), true);
    });

    test('moving the h-file rook drops only that colors kingside right', () {
      final before = Position.fromPieces({Square(7, 0): Piece(.white, .rook)});
      final after = before.applyMove(Move(Square(7, 0), Square(7, 1)));

      expect(after.castlingRight.contains(CastlingStatus.whiteKingSide), false);
      expect(after.castlingRight.contains(CastlingStatus.whiteQueenSide), true);
    });

    test('moving an unrelated piece leaves all rights intact', () {
      final before = Position.fromPieces({Square(1, 0): Piece(.white, .knight)});
      final after = before.applyMove(Move(Square(1, 0), Square(2, 2)));

      expect(after.castlingRight, unorderedEquals(CastlingStatus.values));
    });

    test('applyMove does not mutate the original positions rights', () {
      final before = Position.fromPieces({Square(4, 0): Piece(.white, .king)});

      before.applyMove(Move(Square(4, 0), Square(4, 1))); // apply, discard result

      // the original must still hold all four rights
      expect(before.castlingRight, unorderedEquals(CastlingStatus.values));
    });

    test('capturing a rook on its home square drops that castling right', () {
      // black rook takes the white h1 rook -> white loses kingside castling,
      // even though the piece that moved was the (black) capturer, not the rook.
      final before = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(7, 0): Piece(.white, .rook), // h1
        Square(7, 7): Piece(.black, .rook), // h8, captures down the file
      }, sideToMove: .black);
      final after = before.applyMove(Move(Square(7, 7), Square(7, 0))); // Rh8 x h1
      expect(after.castlingRight.contains(CastlingStatus.whiteKingSide), false);
    });
  });

  group('castling move generation', () {
    // castling surfaces in legalMovesFrom(kingSquare) as the king's 2-square
    // destination: g-file (file 6) = kingside, c-file (file 2) = queenside.

    test('white can castle kingside', () {
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(7, 0): Piece(.white, .rook),
      });
      expect(position.legalMovesFrom(Square(4, 0)), contains(Square(6, 0)));
    });

    test('white can castle queenside', () {
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(0, 0): Piece(.white, .rook),
      });
      expect(position.legalMovesFrom(Square(4, 0)), contains(Square(2, 0)));
    });

    test('black can castle kingside', () {
      final position = Position.fromPieces({
        Square(4, 7): Piece(.black, .king),
        Square(7, 7): Piece(.black, .rook),
      }, sideToMove: .black);
      expect(position.legalMovesFrom(Square(4, 7)), contains(Square(6, 7)));
    });

    test('black can castle queenside', () {
      final position = Position.fromPieces({
        Square(4, 7): Piece(.black, .king),
        Square(0, 7): Piece(.black, .rook),
      }, sideToMove: .black);
      expect(position.legalMovesFrom(Square(4, 7)), contains(Square(2, 7)));
    });

    test('cannot castle without the right', () {
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(7, 0): Piece(.white, .rook),
      }, castlingRight: []);
      expect(position.legalMovesFrom(Square(4, 0)), isNot(contains(Square(6, 0))));
    });

    test('cannot castle when a square between is occupied', () {
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(7, 0): Piece(.white, .rook),
        Square(5, 0): Piece(.white, .bishop), // f1 blocked
      });
      expect(position.legalMovesFrom(Square(4, 0)), isNot(contains(Square(6, 0))));
    });

    test('cannot castle out of check', () {
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(7, 0): Piece(.white, .rook),
        Square(4, 7): Piece(.black, .rook), // checks the king down the e-file
      });
      expect(position.legalMovesFrom(Square(4, 0)), isNot(contains(Square(6, 0))));
    });

    test('cannot castle through an attacked square', () {
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(7, 0): Piece(.white, .rook),
        Square(5, 7): Piece(.black, .rook), // attacks f1, the square the king crosses
      });
      expect(position.legalMovesFrom(Square(4, 0)), isNot(contains(Square(6, 0))));
    });

    test('cannot castle into an attacked square', () {
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(7, 0): Piece(.white, .rook),
        Square(6, 7): Piece(.black, .rook), // attacks g1, the king's landing square
      });
      expect(position.legalMovesFrom(Square(4, 0)), isNot(contains(Square(6, 0))));
    });

    test('queenside: a piece on b1 blocks castling', () {
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(0, 0): Piece(.white, .rook),
        Square(1, 0): Piece(.white, .knight), // b1 occupied — rook can't pass
      });
      expect(position.legalMovesFrom(Square(4, 0)), isNot(contains(Square(2, 0))));
    });

    test('queenside: an attacked-but-empty b1 does NOT block castling', () {
      // b1 only needs to be empty, not safe; an enemy attacking it is fine.
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(0, 0): Piece(.white, .rook),
        Square(1, 7): Piece(.black, .rook), // b8 attacks down the b-file to b1 only
      });
      expect(position.legalMovesFrom(Square(4, 0)), contains(Square(2, 0)));
    });

    test('a king off its home square gets no castling, even with rights', () {
      // white king+rook home (white could castle); black king has wandered;
      // it is black's turn — black must get no phantom castle moves.
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king), // e1
        Square(7, 0): Piece(.white, .rook), // h1
        Square(3, 4): Piece(.black, .king), // d5 — not home
      }, sideToMove: .black);

      expect(position.legalMovesFrom(Square(3, 4)), isNot(contains(Square(6, 7)))); // no g8
      expect(position.legalMovesFrom(Square(3, 4)), isNot(contains(Square(2, 7)))); // no c8
      expect(position.legalMovesFrom(Square(4, 0)), contains(Square(6, 0)));        // white still can
    });

    test('cannot castle when the rook is missing (e.g. captured)', () {
      // king home and right still held, but no rook to castle with.
      final position = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        // no rooks on a1 / h1
      });
      expect(position.legalMovesFrom(Square(4, 0)), isNot(contains(Square(6, 0)))); // no kingside
      expect(position.legalMovesFrom(Square(4, 0)), isNot(contains(Square(2, 0)))); // no queenside
    });
  });

  group('applyMove castling', () {
    test('white kingside moves both king and rook', () {
      final before = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(7, 0): Piece(.white, .rook),
      });
      final after = before.applyMove(Move(Square(4, 0), Square(6, 0))); // e1 -> g1

      expect(after.pieceAt(Square(6, 0)), Piece(.white, .king)); // king on g1
      expect(after.pieceAt(Square(5, 0)), Piece(.white, .rook)); // rook hopped to f1
      expect(after.pieceAt(Square(4, 0)), null);                 // e1 empty
      expect(after.pieceAt(Square(7, 0)), null);                 // h1 empty
      expect(after.sideToMove, PieceColor.black);
    });

    test('white queenside moves both king and rook', () {
      final before = Position.fromPieces({
        Square(4, 0): Piece(.white, .king),
        Square(0, 0): Piece(.white, .rook),
      });
      final after = before.applyMove(Move(Square(4, 0), Square(2, 0))); // e1 -> c1

      expect(after.pieceAt(Square(2, 0)), Piece(.white, .king)); // king on c1
      expect(after.pieceAt(Square(3, 0)), Piece(.white, .rook)); // rook to d1
      expect(after.pieceAt(Square(4, 0)), null);                 // e1 empty
      expect(after.pieceAt(Square(0, 0)), null);                 // a1 empty
    });

    test('black kingside moves both king and rook', () {
      final before = Position.fromPieces({
        Square(4, 7): Piece(.black, .king),
        Square(7, 7): Piece(.black, .rook),
      }, sideToMove: .black);
      final after = before.applyMove(Move(Square(4, 7), Square(6, 7))); // e8 -> g8

      expect(after.pieceAt(Square(6, 7)), Piece(.black, .king)); // king on g8
      expect(after.pieceAt(Square(5, 7)), Piece(.black, .rook)); // rook to f8
      expect(after.pieceAt(Square(4, 7)), null);
      expect(after.pieceAt(Square(7, 7)), null);
    });

    test('black queenside moves both king and rook', () {
      final before = Position.fromPieces({
        Square(4, 7): Piece(.black, .king),
        Square(0, 7): Piece(.black, .rook),
      }, sideToMove: .black);
      final after = before.applyMove(Move(Square(4, 7), Square(2, 7))); // e8 -> c8

      expect(after.pieceAt(Square(2, 7)), Piece(.black, .king)); // king on c8
      expect(after.pieceAt(Square(3, 7)), Piece(.black, .rook)); // rook to d8
      expect(after.pieceAt(Square(4, 7)), null);
      expect(after.pieceAt(Square(0, 7)), null);
    });
  });

  group('en passant', () {
    test('a pawn double-step sets the en passant target', () {
      final before = Position.fromPieces({Square(4, 1): Piece(.white, .pawn)});
      final after = before.applyMove(Move(Square(4, 1), Square(4, 3))); // e2 -> e4
      expect(after.enPassantTarget, Square(4, 2)); // e3, the skipped square
    });

    test('a single-step move sets no en passant target', () {
      final before = Position.fromPieces({Square(4, 1): Piece(.white, .pawn)});
      final after = before.applyMove(Move(Square(4, 1), Square(4, 2))); // e2 -> e3
      expect(after.enPassantTarget, null);
    });

    test('the en passant target is cleared by the following move', () {
      final start = Position.fromPieces({
        Square(4, 1): Piece(.white, .pawn), // e2
        Square(0, 6): Piece(.black, .pawn), // a7, gives black a reply
      });
      final afterDouble = start.applyMove(Move(Square(4, 1), Square(4, 3))); // e2 -> e4
      final afterReply = afterDouble.applyMove(Move(Square(0, 6), Square(0, 5))); // a7 -> a6
      expect(afterReply.enPassantTarget, null); // window closed
    });

    test('an adjacent pawn may capture en passant', () {
      final start = Position.fromPieces({
        Square(4, 1): Piece(.white, .pawn), // e2
        Square(3, 3): Piece(.black, .pawn), // d4, lands beside the pawn after its double-step
        Square(0, 0): Piece(.white, .king), // out of the way (legalMovesFrom needs kings)
        Square(7, 7): Piece(.black, .king),
      });
      final afterDouble = start.applyMove(Move(Square(4, 1), Square(4, 3))); // e2 -> e4, target e3
      // black pawn on d4 can take diagonally onto the empty e3
      expect(afterDouble.legalMovesFrom(Square(3, 3)), contains(Square(4, 2)));
    });

    test('capturing en passant removes the captured pawn', () {
      final start = Position.fromPieces({
        Square(4, 1): Piece(.white, .pawn), // e2
        Square(3, 3): Piece(.black, .pawn), // d4
      });
      final afterDouble = start.applyMove(Move(Square(4, 1), Square(4, 3)));   // e2 -> e4
      final afterCapture = afterDouble.applyMove(Move(Square(3, 3), Square(4, 2))); // d4 x e3 e.p.

      expect(afterCapture.pieceAt(Square(4, 2)), Piece(.black, .pawn)); // black pawn now on e3
      expect(afterCapture.pieceAt(Square(4, 3)), null);                 // captured white pawn (e4) gone
      expect(afterCapture.pieceAt(Square(3, 3)), null);                 // black pawn left d4
    });

    test('mirror: black double-steps and white captures en passant', () {
      final start = Position.fromPieces({
        Square(3, 6): Piece(.black, .pawn), // d7
        Square(4, 4): Piece(.white, .pawn), // e5
      }, sideToMove: .black);
      final afterDouble = start.applyMove(Move(Square(3, 6), Square(3, 4)));   // d7 -> d5, target d6
      final afterCapture = afterDouble.applyMove(Move(Square(4, 4), Square(3, 5))); // e5 x d6 e.p.

      expect(afterCapture.pieceAt(Square(3, 5)), Piece(.white, .pawn)); // white pawn on d6
      expect(afterCapture.pieceAt(Square(3, 4)), null);                 // captured black pawn (d5) gone
      expect(afterCapture.pieceAt(Square(4, 4)), null);                 // white pawn left e5
    });

    test('no en passant without a fresh double-step', () {
      // pawns sit side by side, but no double-step just happened -> no target
      final position = Position.fromPieces({
        Square(4, 4): Piece(.white, .pawn), // e5
        Square(3, 4): Piece(.black, .pawn), // d5
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
      });
      expect(position.legalMovesFrom(Square(4, 4)), isNot(contains(Square(3, 5)))); // no phantom d6
    });

    test('en passant is illegal when it would expose the king (discovered check)', () {
      // white K a5, white P b5, black R h5 all on rank 5. black plays c7-c5;
      // b5 x c6 e.p. would clear rank 5 and leave the king in check -> not legal.
      final start = Position.fromPieces({
        Square(0, 4): Piece(.white, .king), // a5
        Square(1, 4): Piece(.white, .pawn), // b5
        Square(7, 4): Piece(.black, .rook), // h5
        Square(2, 6): Piece(.black, .pawn), // c7
        Square(7, 7): Piece(.black, .king), // h8, out of the way
      }, sideToMove: .black);
      final afterDouble = start.applyMove(Move(Square(2, 6), Square(2, 4))); // c7 -> c5, target c6

      expect(afterDouble.legalMovesFrom(Square(1, 4)), isNot(contains(Square(2, 5)))); // no b5xc6 e.p.
    });
  });

  group('promotion', () {
    test('a white pawn reaching the last rank becomes the chosen piece', () {
      final before = Position.fromPieces({Square(4, 6): Piece(.white, .pawn)}); // e7
      final after = before.applyMove(Move(Square(4, 6), Square(4, 7), promoteTo: .queen)); // e7 -> e8=Q

      expect(after.pieceAt(Square(4, 7)), Piece(.white, .queen)); // queen, not a pawn
      expect(after.pieceAt(Square(4, 6)), null);                  // e7 vacated
    });

    test('underpromotion to a knight is honoured', () {
      final before = Position.fromPieces({Square(4, 6): Piece(.white, .pawn)});
      final after = before.applyMove(Move(Square(4, 6), Square(4, 7), promoteTo: .knight));

      expect(after.pieceAt(Square(4, 7)), Piece(.white, .knight));
    });

    test('a black pawn promotes on rank 0', () {
      final before = Position.fromPieces({Square(4, 1): Piece(.black, .pawn)}, sideToMove: .black); // e2
      final after = before.applyMove(Move(Square(4, 1), Square(4, 0), promoteTo: .queen)); // e2 -> e1=Q

      expect(after.pieceAt(Square(4, 0)), Piece(.black, .queen)); // promoted piece keeps the pawn's colour
    });

    test('promotion by capture lands the new piece on the capture square', () {
      final before = Position.fromPieces({
        Square(3, 6): Piece(.white, .pawn), // d7
        Square(4, 7): Piece(.black, .rook), // e8 enemy
      });
      final after = before.applyMove(Move(Square(3, 6), Square(4, 7), promoteTo: .queen)); // d7 x e8=Q

      expect(after.pieceAt(Square(4, 7)), Piece(.white, .queen)); // captured the rook and promoted
      expect(after.pieceAt(Square(3, 6)), null);
    });

    test('an ordinary move without promoteTo leaves the pawn a pawn', () {
      final before = Position.fromPieces({Square(4, 1): Piece(.white, .pawn)}); // e2
      final after = before.applyMove(Move(Square(4, 1), Square(4, 2))); // e2 -> e3

      expect(after.pieceAt(Square(4, 2)), Piece(.white, .pawn));
    });
  });

  group('insufficient material', () {
    // --- draws: mate is impossible ---

    test('king vs king is a draw', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
      });
      expect(position.isInsufficientMaterial(), true);
    });

    test('king and bishop vs king is a draw', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
        Square(2, 0): Piece(.white, .bishop),
      });
      expect(position.isInsufficientMaterial(), true);
    });

    test('king and knight vs king is a draw', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
        Square(1, 0): Piece(.white, .knight),
      });
      expect(position.isInsufficientMaterial(), true);
    });

    test('the lone minor piece may belong to either side', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
        Square(6, 7): Piece(.black, .knight), // black's knight
      });
      expect(position.isInsufficientMaterial(), true);
    });

    test('same-coloured bishops on each side is a draw', () {
      // c1 (2+0=2, even) and f8 (5+7=12, even) are both dark squares
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
        Square(2, 0): Piece(.white, .bishop),
        Square(5, 7): Piece(.black, .bishop),
      });
      expect(position.isInsufficientMaterial(), true);
    });

    // --- not draws: mate is possible ---

    test('opposite-coloured bishops is NOT insufficient', () {
      // c1 (even, dark) vs c8 (2+7=9, odd, light)
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
        Square(2, 0): Piece(.white, .bishop),
        Square(2, 7): Piece(.black, .bishop),
      });
      expect(position.isInsufficientMaterial(), false);
    });

    test('two knights vs king is NOT insufficient (mate is possible)', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
        Square(1, 0): Piece(.white, .knight),
        Square(6, 0): Piece(.white, .knight),
      });
      expect(position.isInsufficientMaterial(), false);
    });

    test('a queen is sufficient', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
        Square(3, 0): Piece(.white, .queen),
      });
      expect(position.isInsufficientMaterial(), false);
    });

    test('a rook is sufficient', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
        Square(3, 0): Piece(.white, .rook),
      });
      expect(position.isInsufficientMaterial(), false);
    });

    test('a pawn is sufficient (it can promote)', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
        Square(3, 1): Piece(.white, .pawn),
      });
      expect(position.isInsufficientMaterial(), false);
    });

    test('the initial position is not a draw', () {
      expect(Position.initial().isInsufficientMaterial(), false);
    });

    test('two same-coloured bishops (one side) vs king is a draw', () {
      // c1 (2+0=2) and e1 (4+0=4) are both dark — neither can touch a light square
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
        Square(2, 0): Piece(.white, .bishop),
        Square(4, 0): Piece(.white, .bishop),
      });
      expect(position.isInsufficientMaterial(), true);
    });

    test('two opposite-coloured bishops (one side) vs king is NOT a draw', () {
      // c1 (2, dark) and f1 (5, light) cover both colours -> mate is possible
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
        Square(2, 0): Piece(.white, .bishop),
        Square(5, 0): Piece(.white, .bishop),
      });
      expect(position.isInsufficientMaterial(), false);
    });

    test('three same-coloured bishops vs king is a draw', () {
      // reachable via promotion; c1/e1/a3 are all dark, so a light square is
      // still untouchable -> mate impossible.
      final position = Position.fromPieces({
        Square(7, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
        Square(2, 0): Piece(.white, .bishop), // c1, dark
        Square(4, 0): Piece(.white, .bishop), // e1, dark
        Square(0, 2): Piece(.white, .bishop), // a3, dark
      });
      expect(position.isInsufficientMaterial(), true);
    });
  });

  group('fifty-move rule', () {
    // assumes Position exposes an int `halfMoveCounter` (default 0), settable via
    // fromPieces, and isFiftyMove() returns true when it reaches 100.

    test('a quiet move increments the halfmove clock', () {
      final before = Position.fromPieces({
        Square(1, 0): Piece(.white, .knight),
      });
      final after = before.applyMove(Move(Square(1, 0), Square(2, 2))); // Nb1-c3, no capture
      expect(after.halfMoveCounter, 1);
    });

    test('a pawn move resets the halfmove clock', () {
      final before = Position.fromPieces({
        Square(4, 1): Piece(.white, .pawn),
      }, halfMoveCounter: 40);
      final after = before.applyMove(Move(Square(4, 1), Square(4, 2))); // e2-e3
      expect(after.halfMoveCounter, 0);
    });

    test('a capture resets the halfmove clock', () {
      final before = Position.fromPieces({
        Square(0, 0): Piece(.white, .rook),
        Square(0, 5): Piece(.black, .rook),
      }, halfMoveCounter: 40);
      final after = before.applyMove(Move(Square(0, 0), Square(0, 5))); // Rxa6
      expect(after.halfMoveCounter, 0);
    });

    test('reaching 100 half-moves is a draw', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
      }, halfMoveCounter: 100);
      expect(position.isFiftyMove(), true);
    });

    test('99 half-moves is not yet a draw', () {
      final position = Position.fromPieces({
        Square(0, 0): Piece(.white, .king),
        Square(7, 7): Piece(.black, .king),
      }, halfMoveCounter: 99);
      expect(position.isFiftyMove(), false);
    });

    test('an en passant capture resets the halfmove clock', () {
      // e5 x d6 e.p. — a pawn move, so it must reset even from a high count
      final position = Position.fromPieces({
        Square(4, 4): Piece(.white, .pawn), // e5
        Square(3, 4): Piece(.black, .pawn), // d5 (as if it just double-stepped)
      }, enPassantTarget: Square(3, 5), halfMoveCounter: 40);
      final after = position.applyMove(Move(Square(4, 4), Square(3, 5))); // e5 x d6 e.p.
      expect(after.halfMoveCounter, 0);
    });

    test('a promotion resets the halfmove clock', () {
      final position = Position.fromPieces({
        Square(4, 6): Piece(.white, .pawn), // e7
      }, halfMoveCounter: 40);
      final after = position.applyMove(Move(Square(4, 6), Square(4, 7), promoteTo: .queen)); // e7-e8=Q
      expect(after.halfMoveCounter, 0);
    });
  });
}
