import 'package:flutter/material.dart';
import 'othello_board.dart';

// オセロのプレイヤーを表すクラス
class OthelloPlayer {
  // プレイヤーの色
  late Color color;

  // プレイヤーの名前
  late String name;

  // プレイヤーの得点
  late int score;

  // コンストラクタ
  OthelloPlayer(this.color, this.name) {
    // 得点を初期化
    score = 0;
  }

  // プレイヤーの得点を更新するメソッド
  void updateScore(OthelloBoard board) {
    // 盤面上の自分の色の駒の数を数える
    score = board.getCount(color);
  }
}
