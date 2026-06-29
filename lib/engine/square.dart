// Everything is from White's perspective
// file: a-h -> left-right
// rank: 1-8 -> bottom-up
// king's starting position: white e1, black e8
// queen's on her own color

class Square {
  static const int boardSize = 8;

  final int file; // a-h
  final int rank; // 1-8

  // Square(0,0) = a1, (4,3) = e4
  const Square(this.file, this.rank);

  @override
  bool operator ==(Object other) => other is Square && other.file == file && other.rank == rank;

  @override
  int get hashCode => Object.hash(file, rank);

  // file -> ascii (lowercase start from 97), rank (start at 1)
  String get humanNotation => '${String.fromCharCode(97+file)}${rank+1}';

  @override
  String toString() {
    return humanNotation;
  }

  // ensure coordinate in board
  bool get inBound => file >= 0 && file < boardSize && rank >= 0 && rank < boardSize;

  // list of all possible square position in board (8x8)
  static final List<Square> allSquares = [
    for (int rank = 0; rank < boardSize; rank++)
      for (int file = 0; file < boardSize; file++)
        Square(file, rank),
  ];

}