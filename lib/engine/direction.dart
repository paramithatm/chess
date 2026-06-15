// Again, Everything's from White's perspective
// up = rank + 1
enum Direction {
  right(1, 0),
  left(-1, 0),
  up(0, 1),
  down (0, -1),
  
  // diagonal
  upRight(1, 1),
  downRight(1, -1),
  upLeft(-1, 1),
  downLeft(-1, -1);

  final int dFile;
  final int dRank;
  const Direction(this.dFile, this.dRank);

  static const List<Direction> straight = [.down, .up, .left, .right];
  static const List<Direction> diagonal = [.downRight, .upRight, .downLeft, .upLeft];
}