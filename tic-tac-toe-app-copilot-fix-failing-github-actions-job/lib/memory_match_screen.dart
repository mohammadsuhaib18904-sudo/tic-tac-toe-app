import 'package:flutter/material.dart';
import 'dart:math';

class MemoryMatchScreen extends StatefulWidget {
  const MemoryMatchScreen({super.key});

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  static const int gridSize = 4;
  static const int totalPairs = (gridSize * gridSize) ~/ 2;

  static const List<String> _emojis = [
    '🍎', '🍌', '🍇', '🍊', '🍓', '🍒', '🍑', '🍍'
  ];

  late List<String> _cardValues;
  late List<bool> _isFlipped;
  late List<bool> _isMatched;

  int _flips = 0;
  int _matches = 0;
  int? _first;
  int? _second;
  bool _busy = false;
  bool _won = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final values = [..._emojis, ..._emojis]..shuffle(Random());
    _cardValues = values;
    _isFlipped = List.filled(gridSize * gridSize, false);
    _isMatched = List.filled(gridSize * gridSize, false);
    _flips = 0;
    _matches = 0;
    _first = null;
    _second = null;
    _busy = false;
    _won = false;
  }

  void _flip(int i) {
    if (_busy) return;
    if (_isMatched[i]) return;
    if (_isFlipped[i]) return;
    if (_first != null && _second != null) return;

    setState(() {
      _isFlipped[i] = true;
      if (_first == null) {
        _first = i;
      } else {
        _second = i;
        _flips++;
        _busy = true;
        Future.delayed(const Duration(milliseconds: 500), _checkMatch);
      }
    });
  }

  void _checkMatch() {
    if (_first == null || _second == null) {
      _busy = false;
      return;
    }
    final isMatch = _cardValues[_first!] == _cardValues[_second!];
    if (isMatch) {
      setState(() {
        _isMatched[_first!] = true;
        _isMatched[_second!] = true;
        _matches++;
        _first = null;
        _second = null;
        _busy = false;
        if (_matches == totalPairs) _won = true;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        setState(() {
          _isFlipped[_first!] = false;
          _isFlipped[_second!] = false;
          _first = null;
          _second = null;
          _busy = false;
        });
      });
    }
  }

  void _reset() => setState(_initGame);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatBox(label: 'Flips', value: '$_flips', color: Colors.cyanAccent),
                _StatBox(
                    label: 'Matches',
                    value: '$_matches/$totalPairs',
                    color: Colors.pinkAccent),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (_, i) => _Card(
                  index: i,
                  value: _cardValues[i],
                  isFlipped: _isFlipped[i] || _isMatched[i],
                  isMatched: _isMatched[i],
                  isSelected: _first == i || _second == i,
                  onTap: () => _flip(i),
                ),
              ),
            ),
            const SizedBox(height