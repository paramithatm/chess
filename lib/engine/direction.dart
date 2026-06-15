abstract interface class Offset {
    int get dFile;
    int get dRank;
  }

// Again, Everything's from White's perspective
// north = rank + 1
enum Direction implements Offset {
  east(1, 0),
  west(-1, 0),
  north(0, 1),
  south(0, -1),

  // diagonal
  northEast(1, 1),
  southEast(1, -1),
  northWest(-1, 1),
  southWest(-1, -1);

  @override final int dFile;
  @override final int dRank;
  const Direction(this.dFile, this.dRank);

  static const List<Direction> straight = [.south, .north, .west, .east];
  static const List<Direction> diagonal = [.southEast, .northEast, .southWest, .northWest];
}

// Naming follows the Chess Programming Wiki convention: the doubled letter
// marks the long leg of the L (nee = 1 north, 2 east).
// https://www.chessprogramming.org/Knight_Pattern
enum KnightDirection implements Offset {
  nne(1, 2),   // north north east
  nnw(-1, 2),  // north north west
  nee(2, 1),   // north east east
  nww(-2, 1),  // north west west
  see(2, -1),  // south east east
  sww(-2, -1), // south west west
  sse(1, -2),  // south south east
  ssw(-1, -2); // south south west

  @override final int dFile;
  @override final int dRank;
  const KnightDirection(this.dFile, this.dRank);
}