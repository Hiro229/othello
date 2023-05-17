import 'package:flutter/material.dart';
import 'othello_board.dart';
import 'othello_piece.dart';

// オセロのルールを表すクラス
class OthelloRule {
  // 盤面
  OthelloBoard board;

  // コンストラクタ
  OthelloRule(this.board);

  // 指定した色の駒が置ける場所のリストを返すメソッド
  List<OthelloPiece> getAvailablePlaces(Color color) {
    List<OthelloPiece> places = [];
    for (OthelloPiece piece in board.pieces) {
      if (piece.color == Colors.transparent) {
        // 空きマスの場合、8方向にひっくり返せる駒があるかチェックする
        if (canFlip(piece.row, piece.column, color)) {
          // ひっくり返せる駒があれば、置ける場所としてリストに追加する
          places.add(piece);
        }
      }
    }
    return places;
  }

  // 指定した位置に指定した色の駒を置いてひっくり返すメソッド
  void placeAndFlip(int x, int y, Color color) {
    // 駒を置く
    board.setPiece(x, y, color);
    // 8方向にひっくり返せる駒を探す
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue; // 自分自身はスキップする
        // 指定した方向にひっくり返せる駒があれば、ひっくり返す
        if (canFlipDirection(x, y, dx, dy, color)) {
          flipDirection(x, y, dx, dy, color);
        }
      }
    }
  }

  // 指定した位置に指定した色の駒を置いたときに、8方向のいずれかでひっくり返せる駒があるか判定するメソッド
  bool canFlip(int x, int y, Color color) {
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue; // 自分自身はスキップする
        // 指定した方向にひっくり返せる駒があれば、trueを返す
        if (canFlipDirection(x, y, dx, dy, color)) {
          return true;
        }
      }
    }
    return false; // どの方向もひっくり返せなければ、falseを返す
  }

  // 指定した位置に指定した色の駒を置いたときに、指定した方向でひっくり返せる駒があるか判定するメソッド
  bool canFlipDirection(int x, int y, int dx, int dy, Color color) {
    int nx = x + dx;
    int ny = y + dy;
    bool foundOpposite = false; // 相手の色の駒が見つかったかどうか
    while (nx >= 0 && nx < boardSize && ny >= 0 && ny < boardSize) {
      // 盤面内でループする
      OthelloPiece piece = board.getPiece(nx, ny);
      if (piece.color == Colors.transparent) {
        // 空きマスならば
        return false; // ひっくり返せる駒がないと判定する
      } else if (piece.color == color) {
        // 自分の色の駒ならば
        return foundOpposite; // 相手の色の駒が見つかっていれば、ひっくり返せる駒があると判定する
      } else {
        // 相手の色の駒ならば
        foundOpposite = true; // 相手の色の駒が見つかったことを記録する
      }
      // 次のマスに移動する
      nx += dx;
      ny += dy;
    }
    return false; // 盤面の端まで到達したら、ひっくり返せる駒がないと判定する
  }

  // 指定した位置に指定した色の駒を置いたときに、指定した方向でひっくり返せる駒をひっくり返すメソッド
  void flipDirection(int x, int y, int dx, int dy, Color color) {
    int nx = x + dx;
    int ny = y + dy;
    while (nx >= 0 && nx < boardSize && ny >= 0 && ny < boardSize) {
      // 盤面内でループする
      OthelloPiece piece = board.getPiece(nx, ny);
      if (piece.color == color) {
        // 自分の色の駒ならば
        break; // ひっくり返す処理を終了する
      } else {
        // 相手の色の駒ならば
        piece.flip(); // 駒をひっくり返す
      }
      // 次のマスに移動する
      nx += dx;
      ny += dy;
    }
  }
}
