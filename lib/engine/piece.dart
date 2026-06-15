enum PieceColor {
  white,
  black;

  PieceColor get opposite => switch(this) {
    .black => .white,
    .white => .black
  };
}

enum PieceType {
  pawn, // 1 step / 2 step if first move
  rook, // benteng (straight)
  knight, // kuda (L-move)
  bishop, // gajah (diagonal)
  queen, // all direction
  king; // all direction - 1 step
}

class Piece {
  final PieceColor color;
  final PieceType type;

  @override
  bool operator ==(Object other) => other is Piece && other.color == color && other.type == type;
  
  @override
  int get hashCode => Object.hash(color, type);
  
  const Piece(this.color, this.type);

  @override
  String toString() => switch((color, type)) {
     (.black, .queen) => '♛',
     (.black, .king) => '♚',
     (.black, .rook) => '♜',
     (.black, .bishop) => '♝',
     (.black, .knight) => '♞',
     (.black, .pawn) => '♟',
     (.white, .queen) => '♕',
     (.white, .king) => '♔',
     (.white, .rook) => '♖',
     (.white, .bishop) => '♗',
     (.white, .pawn) => '♙',
     (.white, .knight) => '♘'
  };
}