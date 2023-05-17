import 'package:flutter/material.dart';
import 'othello_board.dart';
import 'othello_piece.dart';
import 'othello_rule.dart';

// オセロの盤面を表示するウィジェット
class OthelloBoardWidget extends StatelessWidget {
  // 盤面
  final OthelloBoard board;

  // 駒をタップしたときの処理
  final Function(OthelloPiece) onTap;

  // 駒を置ける場所の色
  final Color availableColor;

  // ルール
  final OthelloRule rule;

  // 手番をパラメータとして受け取る
  final Color turn;

  // コンストラクタ
  OthelloBoardWidget({
    required this.board,
    required this.onTap,
    required this.availableColor,
    required this.rule,
    required this.turn
  });

  @override
  Widget build(BuildContext context) {
    // Containerウィジェットで盤面全体を囲む
    return Container(
      // 背景色を緑に設定する
      color: Colors.green,
      // GridViewウィジェットで盤面をグリッド状に表示する
      child: GridView.builder(
        // 盤面のサイズ（8×8）を指定する
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: boardSize,
        ),
        // 盤面上の駒の数（64）を指定する
        itemCount: boardSize * boardSize,
        // 各駒を表示するウィジェットを生成する
        itemBuilder: (context, index) {
          // 駒のデータを取得する
          OthelloPiece piece = board.pieces[index];
          // 駒を置ける場所かどうか判定する
          bool isAvailable = rule.getAvailablePlaces(turn).contains(piece);
          // Containerウィジェットで駒を囲む
          return Container(
            // 駒の間に隙間を作るためにマージンを指定する
            margin: EdgeInsets.all(2.0),
            // 駒の色と形を指定する（colorプロパティも追加する）
            decoration: BoxDecoration(
              color: piece.color,
              shape: BoxShape.circle,
              border: isAvailable ? Border.all(color: Colors.yellow, width: 1.0) : null, // ここで駒を置ける場所なら黄色の枠線を描く
            ),
            child: InkWell(
              onTap: () => onTap(piece),
            ),
            // 黒色の格子線を描くためにカスタムペイントウィジェットを重ねる
            foregroundDecoration: BoxDecoration( // 前景装飾として設定する
              border: Border.all( // 枠線として設定する
              color: Colors.black, // 色は黒にする
              width: 0.1, // 幅は1.0にする
              ),
            ),
          );
        },
      ),
    );
  }
}
