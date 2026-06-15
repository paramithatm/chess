import 'package:chess/engine/piece.dart';
import 'package:test/test.dart';

void main() {

  group('piece color', () {
    test('opposite of white should be black', () {
      expect(PieceColor.white.opposite, PieceColor.black);
    });

    test('opposite of black should be white', () {
      expect(PieceColor.black.opposite, PieceColor.white);
    });
  });
  
}