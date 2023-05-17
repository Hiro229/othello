import 'package:flutter/material.dart';

// オセロの駒を表すクラス
class OthelloPiece {
  // 駒の位置（x座標）
  int row;

  // 駒の位置（y座標）
  int column;

  // 駒の色
  Color color;

  // コンストラクタ
  OthelloPiece(this.row, this.column, this.color);

  // 駒の色を反転するメソッド
  void flip() {
    if (color == Colors.white) {
      color = Colors.black;
    } else if (color == Colors.black) {
      color = Colors.white;
    }
  }
}
