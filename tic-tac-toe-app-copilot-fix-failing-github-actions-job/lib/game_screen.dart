import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import 'package:neon_tic_tac_toe/board_widget.dart';
import 'package:neon_tic_tac_toe/game_logic.dart';
import 'package:neon_tic_tac_toe/settings_provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameLogic _game = GameLogic();
  int _xWins = 0;
  int _oWins = 0;
  int _draws = 0;

  Future<bool> _hasVibrator() async {
    try {
      return await Vibration.hasVibrator();
    } catch (_) {
      return false;
    }
  }

  Future<void> _vibrate({int duration = 50, List<int>? pattern}) async {
    if (!mounted) return;
    final settings = context.read<SettingsProvider>();
    if (!settings.hapticsEnabled) return;
    if (!await _hasVibrator()) return;
    try {
      if (pattern != null) {
        await Vibration.vibrate(pattern: pattern);
      } else {
        await Vibration.vibrate(duration: duration);
      }
    } catch (e) {
      debugPrint('Vibration error: $e');
    }
  }

  void _handleCellTap(int index) async {
    if (!_game.makeMove(index)) return;
    setState(() {});

    if (_game.winner != null) {
      if (_game.winner == 'X') {
        _xWins++;
      } else {
        _oWins++;
      }
      await _vibrate(pattern: [100, 50, 100, 50, 100]);
      _showResultDialog('Player ${_game.winner} wins!');
    } else if (_game.isDraw) {
      _draws++;
      await _vibrate(duration: 200);
      _showResultDialog("It's a draw!");
    } else {
      await _vibrate(duration: 30);
    }
  }

  void _showResultDialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          message,
          style: const TextStyle(color: Colors.cyanAccent),
        ),
        content: Text(
          'X: $_xWins   O: $_oWins   Draws: $_draws',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(_game.reset);
            },
            child: const Text('Play Again',
                style: TextStyle(color: Colors.pinkAccent)),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(_game.reset);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Scoreboard(
              current: _game.currentPlayer,
              isOver: _game.isGameOver,
              xWins: _xWins,
              oWins: _oWins,
              draws: _draws,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: BoardWidget(
                  board: _game.board,
                  winningLine: _game.winningLine,
                  enabled: !_game.isGameOver,
                  onCellTap: _handleCellTap,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _StatusLine(game: _game),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _resetGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Game'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
            if (settings.hapticsEnabled) ...const [
              SizedBox(height: 6),
              Text(
                'Haptics on',
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Scoreboard extends StatelessWidget {
  final String current;
  final bool isOver;
  final int xWins;
  final int oWins;
  final int draws;

  const _Scoreboard({
    required this.current,
    required this.isOver,
    required this.xWins,
    required this.oWins,
    required this.draws,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ScoreChip(
          label: 'X',
          score: xWins,
          color: Colors.cyanAccent,
          active: !isOver && current == 'X',
        ),
        _ScoreChip(
          label: 'Draws',
          score: draws,
          color: Colors.purpleAccent,
          active: false,
        ),
        _ScoreChip(
          label: 'O',
          score: oWins,
          color: Colors.pinkAccent,
          active: !isOver && current == 'O',
        ),
      ],
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  final bool active;

  const _ScoreChip({
    required this.label,
    required this.score,
    required this.color,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: 0.2) : Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: active ? 2 : 1),
        boxShadow: active
            ? [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 12)]
            : null,
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 14)),
          Text(
            '$score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  final GameLogic game;
  const _StatusLine({required this.game});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    if (game.winner != null) {
      text = 'Player ${game.winner} wins!';
      color = Colors.greenAccent;
    } else if (game.isDraw) {
      text = 'Draw!';
      color = Colors.purpleAccent;
    } else {
      text = "Player ${game.currentPlayer}'s turn";
      color = game.currentPlayer == 'X' ? Colors.cyanAccent : Colors.pinkAccent;
    }
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        shadows: [Shadow(color: color.withValues(alpha: 0.7), blurRadius: 10)],
      ),
    );
  }
}