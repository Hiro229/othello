import 'package:flutter/material.dart';
import 'othello_piece.dart';

// オセロの盤面のサイズ（8×8）
const int boardSize = 8;

// オセロの盤面を表すクラス
class OthelloBoard {
  // 盤面上の駒のリスト
  late List<OthelloPiece> pieces;

// コンストラクタ
  OthelloBoard() {
    // 駒のリストを空のリストで初期化
    pieces = [];
    // 盤面のサイズ分だけ駒を作成
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        // 駒の色を決める（初期状態では中央に白黒が交互に並ぶ）
        Color color;
        if ((i == 3 && j == 3) || (i == 4 && j == 4)) {
          color = Colors.white;
        } else if ((i == 3 && j == 4) || (i == 4 && j == 3)) {
          color = Colors.black;
        } else {
          color = Colors.transparent;
        }
        // 駒を作成してリストに追加
        pieces.add(OthelloPiece(i, j, color));
      }
    }
  }

  // 盤面上の空きマスの数を返すメソッド
  int getEmptyCount() {
    int count = 0;
    for (OthelloPiece piece in pieces) {
      if (piece.color == Colors.transparent) {
        count++;
      }
    }
    return count;
  }

  // 盤面上の指定した色の駒の数を返すメソッド
  int getCount(Color color) {
    int count = 0;
    for (OthelloPiece piece in pieces) {
      if (piece.color == color) {
        count++;
      }
    }
    return count;
  }

  // 盤面上の指定した位置にある駒を返すメソッド
  OthelloPiece getPiece(int x, int y) {
    return pieces[x * boardSize + y];
  }

  // 盤面上の指定した位置に駒を置くメソッド
  void setPiece(int x, int y, Color color) {
    getPiece(x, y).color = color;
  }

  // 盤面をコピーして返すメソッド
  OthelloBoard clone() {
    // 新しい盤面を作成する
    OthelloBoard newBoard = OthelloBoard();
    // 駒のリストを空にする
    newBoard.pieces = [];
    // 現在の盤面の駒のリストから一つずつコピーする
    for (OthelloPiece piece in pieces) {
      // 駒の位置と色をそのまま引き継ぐ
      newBoard.pieces.add(OthelloPiece(piece.row, piece.column, piece.color));
    }
    // 新しい盤面を返す
    return newBoard;
  }

  // 指定した場所に駒を置くとともに、反転するべき駒も反転させるメソッド
  void putPiece(OthelloBoard board, OthelloPiece piece) {
    // 駒を置く
    board.setPiece(piece.row, piece.column, piece.color);
    // 反転する方向のリストを取得する
    List<Offset> directions = getFlipDirections(board, piece);
    // 各方向について反転する駒を探す
    for (Offset direction in directions) {
      // 隣のマスから始める
      // int x = piece.row + direction.dx;
      // int y = piece.column + direction.dy;
      // 変換する場合
      int x = piece.row.toInt() + direction.dx.toInt();
      int y = piece.column.toInt() + direction.dy.toInt();
      // 盤面の範囲内で繰り返す
      while (x >= 0 && x < boardSize && y >= 0 && y < boardSize) {
        // 隣のマスの駒を取得する
        OthelloPiece next = board.getPiece(x, y);
        // 隣のマスが空か自分と同じ色ならば、反転する駒はないので終了
        if (next.color == Colors.transparent || next.color == piece.color) {
          break;
        } else {
          // 隣のマスが相手の色ならば、反転させる
          next.color = piece.color;
          // 次のマスに移動する
          x += direction.dx.toInt();
          y += direction.dy.toInt();
        }
      }
    }
  }

  // 指定した場所に駒を置いたときに、反転する方向のリストを返すメソッド
  List<Offset> getFlipDirections(OthelloBoard board, OthelloPiece piece) {
    // 反転する方向のリストを作成する
    List<Offset> directions = [];
    // 縦横斜めの8方向について調べる
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        // 同じ場所は除く
        if (dx == 0 && dy == 0) {
          continue;
        }
        // 隣のマスから始める
        int x = piece.row + dx;
        int y = piece.column + dy;
        // 盤面の範囲内で繰り返す
        while (x >= 0 && x < boardSize && y >= 0 && y < boardSize) {
          // 隣のマスの駒を取得する
          OthelloPiece next = board.getPiece(x, y);
          // 隣のマスが空ならば、反転する駒はないので終了
          if (next.color == Colors.transparent) {
            break;
          }
          // 隣のマスが自分と同じ色ならば、反転する方向としてリストに追加して終了
          if (next.color == piece.color) {
            // directions.add(Offset(dx, dy));
            // directions.add(Offset(dx.toDouble(), dy.toDouble()));
            directions.add(Offset(dx / 1, dy / 1));
            break;
          }
          // 隣のマスが相手の色ならば、次のマスに移動する
          x += dx;
          y += dy;
        }
      }
    }
    // 反転する方向のリストを返す
    return directions;
  }

  // 指定した色の駒の数を数えるメソッド
  int countPieces(Color color) {
    // 駒の数を初期化する
    int count = 0;
    // 駒のリストから一つずつ取り出す
    for (OthelloPiece piece in pieces) {
      // 駒の色が指定した色と同じならば、カウントを増やす
      if (piece.color == color) {
        count++;
      }
    }
    // 駒の数を返す
    return count;
  }
}
