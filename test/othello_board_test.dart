// import 'package:flutter_test/flutter_test.dart';
// import 'lib/src/play_othello/othello_board.dart';
//
// void main() {
//   // OthelloBoardクラスのインスタンスを作成
//   OthelloBoard board = OthelloBoard();
//
//   // getEmptyCountメソッドのテスト
//   test('getEmptyCount returns the number of empty places on the board', () {
//     // 初期状態では空きマスは60個あるはず
//     expect(board.getEmptyCount(), 60);
//     // 適当な場所に駒を置いてみる
//     board.setPiece(0, 0, Colors.white);
//     // 空きマスは59個に減るはず
//     expect(board.getEmptyCount(), 59);
//   });
//
//   // getCountメソッドのテスト
//   test('getCount returns the number of pieces of the specified color on the board', () {
//     // 初期状態では白と黒は2個ずつあるはず
//     expect(board.getCount(Colors.white), 2);
//     expect(board.getCount(Colors.black), 2);
//     // 適当な場所に駒を置いてみる
//     board.setPiece(0, 0, Colors.white);
//     board.setPiece(1, 1, Colors.black);
//     // 白と黒はそれぞれ3個に増えるはず
//     expect(board.getCount(Colors.white), 3);
//     expect(board.getCount(Colors.black), 3);
//   });
//
//   // getPieceメソッドのテスト
//   test('getPiece returns the piece at the specified position on the board', () {
//     // 初期状態では中央に白黒が交互に並んでいるはず
//     expect(board.getPiece(3, 3).color, Colors.white);
//     expect(board.getPiece(3, 4).color, Colors.black);
//     expect(board.getPiece(4, 3).color, Colors.black);
//     expect(board.getPiece(4, 4).color, Colors.white);
//     // 適当な場所に駒を置いてみる
//     board.setPiece(0, 0, Colors.white);
//     board.setPiece(1, 1, Colors.black);
//     // 置いた場所に駒があるはず
//     expect(board.getPiece(0, 0).color, Colors.white);
//     expect(board.getPiece(1, 1).color, Colors.black);
//   });
//
//   // setPieceメソッドのテスト
//   test('setPiece sets the piece of the specified color at the specified position on the board', () {
//     // 適当な場所に駒を置いてみる
//     board.setPiece(0, 0, Colors.white);
//     board.setPiece(1, 1, Colors.black);
//     // 置いた場所に駒があるはず
//     expect(board.getPiece(0, 0).color, Colors.white);
//     expect(board.getPiece(1, 1).color, Colors.black);
//     // 置いた場所に別の色の駒を置いてみる
//     board.setPiece(0, 0, Colors.black);
//     board.setPiece(1, 1, Colors.white);
//     // 置いた場所に駒の色が変わるはず
//     expect(board.getPiece(0, 0).color, Colors.black);
//     expect(board.getPiece(1, 1).color, Colors.white);
//   });
// }
