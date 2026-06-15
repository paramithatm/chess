import 'package:chess/engine/square.dart';
import 'package:test/test.dart';

void main() {
  test('same square value should be equal', () {
    // necessary because class in dart is by reference, checks is it same object (identity equality)
    // need to override == and hashcode in order to make it equal by value (value equality)
    expect(Square(4, 3), Square(4, 3));
  });

  test('different square value should not be equal', () {
    expect(Square(0, 0), isNot(Square(4, 3)));
  });

  test('human notation', () {
    expect(Square(4, 3).humanNotation, 'e4');
    expect(Square(0, 0).humanNotation, 'a1');
    expect(Square(7, 7).humanNotation, 'h8');
  });
}
