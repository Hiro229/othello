
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import 'othello_ai.dart';
import 'othello_board.dart';
import 'othello_player.dart';
import 'othello_piece.dart';
import 'othello_rule.dart';
import 'othello_board_widget.dart';
import '../level_selection/levels.dart';

// ゲーム画面を表すウィジェット
class GameScreen extends StatefulWidget {
  // レベルの情報を受け取るパラメータを追加します
  final GameLevel level;

  const GameScreen(this.level, {super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static final _log = Logger('GameScreen');
  // 盤面
  late OthelloBoard board;

  // ルール
  late OthelloRule rule;

  // プレイヤー1（白）
  late OthelloPlayer player1;

  // プレイヤー2（黒）
  late OthelloAI player2;

  // 手番
  late Color turn;

  // ゲーム終了フラグ
  late bool isGameOver;

  @override
  void initState() {
    super.initState();
    // 新しいゲームを開始する
    startNewGame();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffoldウィジェットでゲーム画面のレイアウトを構築する
    return Scaffold(
      // タイトルバーを表示する
      appBar: AppBar(
        title: Text('オセロ'),
      ),
      // 縦方向に要素を並べる
      body: Column(
        children: [
          // 空白を作る
          SizedBox(height: 50), // 高さ20の空白を作る
          // 横方向に要素を並べる
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 要素を中央寄せにする
            children: [
              // プレイヤー1（白）の名前と得点を表示する
              Text('${player1.name}: ${player1.score}',
                style: TextStyle(fontSize: 24), // 文字サイズを24にする
              ),
              // 空白を作る
              SizedBox(width: 20), // 幅20の空白を作る
              // 現在の手番の色を表示する
              Text('手番: ${turn == Colors.white ? '白' : '黒'}',
                style: TextStyle(fontSize: 24), // 文字サイズを24にする
              ),
              // 空白を作る
              SizedBox(width: 20), // 幅20の空白を作る
              // プレイヤー2（黒）の名前と得点を表示する
              Text('${player2.name}: ${player2.score}',
                style: TextStyle(fontSize: 24), // 文字サイズを24にする
              ),
            ],
          ),
          // 残りの領域を埋める
          Expanded(
            child: Center(
              child: AspectRatio(
                // アスペクト比（縦横比）を1:1に指定する
                aspectRatio: 1.0,
                child: OthelloBoardWidget(
                  // 盤面を表示する
                  board: board,
                  // 駒をタップしたときの処理を指定する
                  onTap: (piece) {
                    // 駒を置く処理を行う
                    placePiece(piece);
                  },
                  // 駒を置ける場所の色を指定する（例：緑）
                  availableColor: Colors.yellow,

                  rule: rule,

                  // 手番を引数として渡す
                  turn: turn,
                ),
              ),
            ),
          ),
          // 横方向に要素を並べる
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 要素を中央寄せにする
            children: [
              // 「新しいゲーム」ボタンを表示する
              ElevatedButton(
                child: Text('新しいゲーム'),
                onPressed: () {
                  // 新しいゲームを開始する処理を行う
                  startNewGame();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 新しいゲームを開始するメソッド
  void startNewGame() {
    // 盤面とプレイヤーの得点を初期化する
    board = OthelloBoard();
    rule = OthelloRule(board);
    player1 = OthelloPlayer(Colors.white, 'あなた');
    // ルートからレベルの値を取得する
    player2 = OthelloAI(Colors.black, 'AI', widget.level.number);
    player1.updateScore(board);
    player2.updateScore(board);
    // 手番を白に設定する
    turn = Colors.white;
    // ゲーム終了フラグをfalseに設定する
    isGameOver = false;
    // 画面を更新する
    setState(() {});
  }

  // 駒を置くメソッド
  void placePiece(OthelloPiece piece) {
    // 駒が置ける場所かどうか判定する
    if (rule.getAvailablePlaces(turn).contains(piece)) {
      // 置ける場合は盤面に駒を置き、ひっくり返す処理を行う
      rule.placeAndFlip(piece.row, piece.column, turn);
      // プレイヤーの得点を更新する
      player1.updateScore(board);
      player2.updateScore(board);
      // 手番を交代する
      turn = turn == Colors.white ? Colors.black : Colors.white;
      // ゲームが終了したかどうか判定する
      if (rule.getAvailablePlaces(Colors.white).isEmpty &&
          rule.getAvailablePlaces(Colors.black).isEmpty) {
        // 置ける場所がない場合はゲーム終了フラグをtrueに設定する
        isGameOver = true;
        // 勝敗の判定を行う
        judgeWinner();
      } else {
        // 置ける場所がある場合は相手にターンを渡す前に、相手が置ける場所があるかどうか判定する
        if (rule.getAvailablePlaces(turn).isEmpty) {
          // 相手が置ける場所がない場合は、もう一度自分のターンに戻す
          turn = turn == Colors.white ? Colors.black : Colors.white;
          // 相手のターンになることを２秒間表示する
          showTurnMessage();
        }

      }
      // 画面を更新する
      setState(() {});
      // AIの手番の場合はAIの処理を行う
      if (turn == Colors.black && !isGameOver) {
        aiTurn();
      }
    }
  }

  // AIの手番のメソッド
  void aiTurn() async {
    // 少し遅延させることで、AIが考えているように見せる
    await Future.delayed(Duration(seconds: 1));
    // AIが駒を置く場所を決める
    OthelloPiece? piece = player2.decidePlace(board, rule);
    // 修正箇所：pieceがnullの場合は勝敗判定を行う
    if (piece == null) {
      // ゲーム終了フラグをtrueに設定する
      isGameOver = true;
      // 勝敗の判定を行う
      judgeWinner();
    }
    // 駒を置く処理を行う
    placePiece(piece!);
  }

  // 勝敗の判定を行うメソッド
  void judgeWinner() {
    // プレイヤーの得点を比較する
    if (player1.score > player2.score) {
      // プレイヤー1（白）の得点が高い場合はプレイヤー1（白）の勝ちと表示する
      showWinnerMessage('${player1.name}（白）の勝ちです！');
    } else if (player1.score < player2.score) {
      // プレイヤー2（黒）の得点が高い場合はプレイヤー2（黒）の勝ちと表示する
      showWinnerMessage('${player2.name}（黒）の勝ちです！');
    } else {
      // プレイヤーの得点が同じ場合は引き分けと表示する
      showWinnerMessage('引き分けです！');
    }
  }

  // 勝者のメッセージを表示するメソッド
  void showWinnerMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ゲーム終了'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('トップ画面に戻る'),
            onPressed: () {
              Navigator.pop(context); // ダイアログを閉じる
              Navigator.pop(context); // ゲーム画面からトップ画面に戻る
            },
          ),
        ],
      ),
    );
  }

  // 相手のターンになるメッセージを表示するメソッド
  void showTurnMessage() async {
    // ダイアログを表示する
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${turn == Colors.white ? player1.name : player2.name}のターンになりました'), // 相手の名前を表示する
      ),
      barrierDismissible: false, // ダイアログ外をタップしても閉じない
    );
    // 1秒後にダイアログを閉じる
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
  }
}
