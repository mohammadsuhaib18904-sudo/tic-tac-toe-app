import 'package:flutter_test/flutter_test.dart';
import 'package:neon_tic_tac_toe/game_logic.dart';

void main() {
  group('GameLogic', () {
    late GameLogic gameLogic;

    setUp(() {
      gameLogic = GameLogic();
    });

    test('Initial state', () {
      expect(gameLogic.currentPlayer, 'X');
      expect(gameLogic.board, List.filled(9, ''));
      expect(gameLogic.winner, isNull);
      expect(gameLogic.isDraw, isFalse);
      expect(gameLogic.isGameOver, isFalse);
    });

    test('Make a move', () {
      gameLogic.makeMove(0);
      expect(gameLogic.board[0], 'X');
      expect(gameLogic.currentPlayer, 'O');
    });

    test('Cannot overwrite a cell', () {
      gameLogic.makeMove(0);
      gameLogic.makeMove(0);
      expect(gameLogic.board[0], 'X');
      expect(gameLogic.currentPlayer, 'O');
    });

    test('Win detection - row', () {
      gameLogic.makeMove(0); // X
      gameLogic.makeMove(3); // O
      gameLogic.makeMove(1); // X
      gameLogic.makeMove(4); // O
      gameLogic.makeMove(2); // X wins
      expect(gameLogic.winner, 'X');
      expect(gameLogic.isGameOver, isTrue);
      expect(gameLogic.winningLine, [0, 1, 2]);
    });

    test('Win detection - column', () {
      gameLogic.makeMove(0); // X
      gameLogic.makeMove(1); // O
      gameLogic.makeMove(3); // X
      gameLogic.makeMove(4); // O
      gameLogic.makeMove(6); // X wins
      expect(gameLogic.winner, 'X');
      expect(gameLogic.isGameOver, isTrue);
      expect(gameLogic.winningLine, [0, 3, 6]);
    });

    test('Win detection - diagonal', () {
      gameLogic.makeMove(0); // X
      gameLogic.makeMove(1); // O
      gameLogic.makeMove(4); // X
      gameLogic.makeMove(2); // O
      gameLogic.makeMove(8); // X wins
      expect(gameLogic.winner, 'X');
      expect(gameLogic.isGameOver, isTrue);
      expect(gameLogic.winningLine, [0, 4, 8]);
    });

    test('Draw detection', () {
      gameLogic.makeMove(0); // X
      gameLogic.makeMove(1); // O
      gameLogic.makeMove(2); // X
      gameLogic.makeMove(4); // O
      gameLogic.makeMove(3); // X
      gameLogic.makeMove(5); // O
      gameLogic.makeMove(7); // X
      gameLogic.makeMove(6); // O
      gameLogic.makeMove(8); // X
      expect(gameLogic.winner, isNull);
      expect(gameLogic.isDraw, isTrue);
      expect(gameLogic.isGameOver, isTrue);
    });

    test('Reset game', () {
      gameLogic.makeMove(0);
      gameLogic.makeMove(1);
      gameLogic.reset();
      expect(gameLogic.currentPlayer, 'X');
      expect(gameLogic.board, List.filled(9, ''));
      expect(gameLogic.winner, isNull);
      expect(gameLogic.isDraw, isFalse);
      expect(gameLogic.isGameOver, isFalse);
    });
  });
}