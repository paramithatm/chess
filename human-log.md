/*
a8 b8 c8 d8 e8 f8 g8 h8
a7 b7 c7 d7 e7 f7 g7 h7
a6 b6 c6 d6 e6 f6 g6 h6
a5 b5 c5 d5 e5 f5 g5 h5
a4 b4 c4 d4 e4 f4 g4 h4
a3 b3 c3 d3 e3 f3 g3 h3
a2 b2 c2 d2 e2 f2 g2 h2
a1 b1 c1 d1 e1 f1 g1 h1
*/

How I made this with the guide of Claude:
1. init flutter project, straight forward
2. data model (piece, square, board (position at any given time)), preview in console

learning enum, const, final, static, factory, named constructor; basic dart concepts
https://news.dartlang.org/2012/06/const-static-final-oh-my.html

data modeling:
piece -> know its color, type
square -> know its coordinate

position -> 
a. know what's in a square (pieceAt)
b. can draw a board based on given position (fromPiece)
- basically a & b handle conversion between square(file, rank) to board[rank][file]

3. piece move rules (straight, diagonal, all direction, L-shaped for knight)

all the while doing it the TDD way, write test to prove engine is correct, because no UI yet to test

rook, bishop, queen, is pretty straight forward (sliding moves)

test getting tedious so asked claude to generate case & answers based on provided examples

knight is a bit specific, because it jumps over (doesn't need to check neighbors)

move generation is quite a place where i refactor some things over

thought process:
1. create rook move method, brute force 1 direction
2. need to check all direction, doing 1 by 1 = code repetition. so create direction enum, loop all direction (4x max 7)
3. similar with bishop except direction is diagonal. extract to slidingMove
4. same with queen but all direction
5. knight is different altogether so preparing a steppingMove
6. king can reuse steppingMove, but logic wise it's queen, a bit weird
7. quite a big refactor to reuse the move logic, extract status of (square), check whether empty / ally / enemy / invalid
8. 