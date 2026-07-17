import 'package:flutter/material.dart';
import 'dart:math';

enum RpsChoice { rock, paper, scissors }

extension RpsChoiceX on RpsChoice {
  String get label {
    switch (this) {
      case RpsChoice.rock:
        return 'Rock';
      case RpsChoice.paper:
        return 'Paper';
      case RpsChoice.scissors:
        return 'Scissors';
    }
  }

  IconData get icon {
    switch (this) {
      case RpsChoice.rock:
        return Icons.diamond;
      case RpsChoice.paper:
        return Icons.description;
      case RpsChoice.scissors:
        return Icons.content_cut;
    }
  }

  static RpsChoice fromIndex(int i) =>
      RpsChoice.values[i % RpsChoice.values.length];
}

enum RpsOutcome { win, lose, draw }

RpsOutcome judgeRps(RpsChoice p, RpsChoice c) {
  if (p == c) return RpsOutcome.draw;
  if ((p == RpsChoice.rock && c == RpsChoice.scissors) ||
      (p == RpsChoice.paper && c == RpsChoice.rock) ||
      (p == RpsChoice.scissors && c == RpsChoice.paper)) {
    return RpsOutcome.win;
  }
  return RpsOutcome.lose;
}

class _RoundResult {
  final RpsChoice player;
  final RpsChoice cpu;
  final RpsOutcome outcome;
  const _RoundResult(this.player, this.cpu, this.outcome);
}

class RockPaperScissorsScreen extends StatefulWidget {
  const RockPaperScissorsScreen({super.key});

  @override
  State<RockPaperScissorsScreen> createState() => _RockPaperScissorsScreenState();
}

class _RockPaperScissorsScreenState extends State<RockPaperScissorsScreen> {
  final Random _rng = Random();
  RpsChoice? _player;
  RpsChoice? _cpu;
  RpsOutcome? _outcome;
  int _wins = 0;
  int _losses = 0;
  int _draws = 0;
  final List<_RoundResult> _history = [];

  void _play(RpsChoice choice) {
    final cpu = RpsChoiceX.fromIndex(_rng.nextInt(3));
    final outcome = judgeRps(choice, cpu);
    setState(() {
      _player = choice;
      _cpu = cpu;
      _outcome = outcome;
      _history.insert(0, _RoundResult(choice, cpu, outcome));
      if (_history.length > 10) _history.removeLast();
      switch (outcome) {
        case RpsOutcome.win:
          _wins++;
          break;
        case RpsOutcome.lose:
          _losses++;
          break;
        case RpsOutcome.draw:
          _draws++;
          break;
      }
    });
  }

  void _reset() {
    setState(() {
      _player = null;
      _cpu = null;
      _outcome = null;
      _wins = 0;
      _losses = 0;
      _draws = 0;
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ScoreHeader(wins: _wins, losses: _losses, draws: _draws),
            const SizedBox(height: 16),
            Expanded(
              child: _outcome == null
                  ? const _Prompt()
                  : _RoundView(player: _player!, cpu: _cpu!, outcome: _outcome!),
            ),
            if (_history.isNotEmpty) _HistoryStrip(history: _history),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: RpsChoice.values
                  .map((c) => _ChoiceButton(choice: c, onTap: () => _play(c)))
                  .toList(),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh, color: Colors.white70),
              label: const Text('Reset', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreHeader extends StatelessWidget {
  final int wins, losses, draws;
  const _ScoreHeader({required this.wins, required this.losses, required this.draws});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatBox(label: 'Wins', value: wins, color: Colors.greenAccent),
        _StatBox(label: 'Draws', value: draws, color: Colors.purpleAccent),
        _StatBox(label: 'Losses', value: losses, color: Colors.redAccent),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.1),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 12)),
          Text(
            '$value',
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Pick your move',
        style: TextStyle(
            color: Colors.white70, fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _RoundView extends StatelessWidget {
  final RpsChoice player;
  final RpsChoice cpu;
  final RpsOutcome outcome;
  const _RoundView({required this.player, required this.cpu, required this.outcome});

  @override
  Widget build(BuildContext context) {
    final msg = switch (outcome) {
      RpsOutcome.win => 'You win!',
      RpsOutcome.lose => 'You lose!',
      RpsOutcome.draw => 'Draw!',
    };
    final color = switch (outcome) {
      RpsOutcome.win => Colors.greenAccent,
      RpsOutcome.lose => Colors.redAccent,
      RpsOutcome.draw => Colors.purpleAccent,
    };
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _BigChoice(label: 'You', choice: player, color: Colors.cyanAccent),
            const Text('VS',
                style: TextStyle(
                    color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            _BigChoice(label: 'CPU', choice: cpu, color: Colors.pinkAccent),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          msg,
          style: TextStyle(
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: color.withValues(alpha: 0.7), blurRadius: 10)],
          ),
        ),
      ],
    );
  }
}

class _BigChoice extends StatelessWidget {
  final String label;
  final RpsChoice choice;
  final Color color;
  const _BigChoice({required this.label, required this.choice, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: 2),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 14),
            ],
          ),
          child: Icon(choice.icon, size: 60, color: color),
        ),
        const SizedBox(height: 6),
        Text(choice.label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class _HistoryStrip extends StatelessWidget {
  final List<_RoundResult> history;
  const _HistoryStrip({required this.history});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: history.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final r = history[i];
          final color = switch (r.outcome) {
            RpsOutcome.win => Colors.greenAccent,
            RpsOutcome.lose => Colors.redAccent,
            RpsOutcome.draw => Colors.purpleAccent,
          };
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${r.player.label[0]} vs ${r.cpu.label[0]}',
              style: TextStyle(color: color, fontSize: 12),
            ),
          );
        },
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final RpsChoice choice;
  final VoidCallback onTap;
  const _ChoiceButton({required this.choice, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.purpleAccent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withValues(alpha: 0.4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Icon(choice.icon, size: 50, color: Colors.pinkAccent),
      ),
    );
  }
}