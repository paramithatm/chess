import 'package:chess/engine/piece.dart';
import 'package:chess/engine/square.dart';

class Move {
  final Square from;
  final Square to;
  final PieceType? promoteTo;

  const Move(this.from, this.to, {this.promoteTo});

  @override
  bool operator ==(Object other) {
    return other is Move && other.from == from && other.to == to && other.promoteTo == promoteTo;
  }

  @override
  int get hashCode => Object.hash(from, to, promoteTo);
}