import 'dart:math';
import 'package:flutter/material.dart';
import 'othello_board.dart';
import 'othello_piece.dart';
import 'othello_player.dart';
import 'othello_rule.dart';

// オセロのAIプレイヤーを表すクラス
class OthelloAI extends OthelloPlayer {
  // ランダムな数値を生成するオブジェクト
  late Random random;

  // レベルの番号を受け取るパラメータを追加する
  final int level;

  // コンストラクタ
  OthelloAI(Color color, String name, this.level) : super(color, name) {
    // ランダムな数値を生成するオブジェクトを初期化
    random = Random();
  }

  // 駒を置く場所を決めるメソッド
  OthelloPiece? decidePlace(OthelloBoard board, OthelloRule rule) {
    // 置ける場所のリストを取得する
    List<OthelloPiece> places = rule.getAvailablePlaces(color);
    if (places.isEmpty) {
      // 置ける場所がなければ、nullを返す
      return null;
    } else {
      // レベルの番号に応じて異なるロジックを実行する
      switch (level) {
        case 1:
        // 1レベル：自分が駒をおける場所の中で、ランダムに置く
          return places[random.nextInt(places.length)];
        case 2:
        // 2レベル：自分が駒をおける場所の中で、相手の駒が反転するが数が最小の場所に駒を置く
          return findMinFlipPlace(places, board, rule);
        case 3:
        // 3レベル：自分が駒をおける場所の中で、相手の駒が反転するが数が最大の場所に駒を置く
          return findMaxFlipPlace(places, board, rule);
        case 4:
        // 4レベル：自分が駒をおける場所の中で、外側に一番近いところに置く
          return findOuterPlace(places);
        case 5:
        // 5レベル：AIが勝利するように駒を置く（未実装）
          return null;
        default:
        // デフォルトではランダムに置く
          return places[random.nextInt(places.length)];
      }
    }
  }

  // 相手の駒が反転する数が最小になる場所を探すメソッド
  OthelloPiece? findMinFlipPlace(List<OthelloPiece> places, OthelloBoard board, OthelloRule rule) {
    // 最小の反転数とその場所を記録する変数
    int minFlip = boardSize * boardSize;
    OthelloPiece? minPlace;

    // 置ける場所のリストから一つずつ試す
    for (OthelloPiece place in places) {
      // 駒を仮に置いてみる（盤面はコピーして操作する）
      OthelloBoard testBoard = board.clone();
      testBoard.putPiece(board, place);

      // 反転した駒の数を数える（相手の色と逆になっている駒の数）
      int flipCount = testBoard.countPieces(Colors.white);

      // 反転数が最小より小さければ、更新する
      if (flipCount < minFlip) {
        minFlip = flipCount;
        minPlace = place;
      }
    }

    // 最小の反転数になる場所を返す（なければnull）
    return minPlace;
  }

// 相手の駒が反転する数が最大になる場所を探すメソッド
  OthelloPiece? findMaxFlipPlace(List<OthelloPiece> places, OthelloBoard board, OthelloRule rule) {
    // 最大の反転数とその場所を記録する変数
    int maxFlip = 0;
    OthelloPiece? maxPlace;

    // 置ける場所のリストから一つずつ試す
    for (OthelloPiece place in places) {
      // 駒を仮に置いてみる（盤面はコピーして操作する）
      OthelloBoard testBoard = board.clone();
      testBoard.putPiece(board, place);

      // 反転した駒の数を数える（相手の色と逆になっている駒の数）
      int flipCount = testBoard.countPieces(Colors.white);

      // 反転数が最大より大きければ、更新する
      if (flipCount > maxFlip) {
        maxFlip = flipCount;
        maxPlace = place;
      }
    }

    // 最大の反転数になる場所を返す（なければnull）
    return maxPlace;
  }

  // 外側に一番近い場所を探すメソッド
  OthelloPiece? findOuterPlace(List<OthelloPiece> places) {
    // 外側の距離とその場所を記録する変数
    int minDistance = boardSize;
    OthelloPiece? minPlace;

    // 置ける場所のリストから一つずつ試す
    for (OthelloPiece place in places) {
      // 駒の位置から外側までの距離を計算する（縦横斜めの最小値）
      // int distance = min(place.row, place.column, boardSize - 1 - place.row, boardSize - 1 - place.column);
      // 駒の位置から外側までの距離を計算する（縦横斜めの最小値）
      int distance = min(min(place.row, place.column), min(boardSize - 1 - place.row, boardSize - 1 - place.column));
      // 距離が最小より小さければ、更新する
      if (distance < minDistance) {
        minDistance = distance;
        minPlace = place;
      }
    }

    // 最小の距離になる場所を返す（なければnull）
    return minPlace;
  }

// レベル5のロジックは未実装です
}
