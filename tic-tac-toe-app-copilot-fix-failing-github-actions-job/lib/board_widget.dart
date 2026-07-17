import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  final List<String> board;
  final ValueChanged<int> onCellTap;
  final List<int>? winningLine;
  final bool enabled;

  const BoardWidget({
    super.key,
    required this.board,
    required this.onCellTap,
    this.winningLine,
    this.enabled = true,
  }) : assert(board.length == 9, 'board must be 9 cells');

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.cyan, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.cyan.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 9,
          itemBuilder: (_, i) => _Cell(
            index: i,
            value: board[i],
            isWinning: winningLine?.contains(i) ?? false,
            enabled: enabled && board[i].isEmpty,
            onTap: () => onCellTap(i),
          ),
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final int index;
  final String value;
  final bool isWinning;
  final bool enabled;
  final VoidCallback onTap;

  const _Cell({
    required this.index,
    required this.value,
    required this.isWinning,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(value, isWinning);
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isWinning
                ? Colors.greenAccent
                : (enabled
                    ? Colors.purpleAccent
                    : Colors.purple.withValues(alpha: 0.3)),
            width: isWinning ? 3 : 2,
          ),
          boxShadow: isWinning
              ? [
                  BoxShadow(
                    color: Colors.greenAccent.withValues(alpha: 0.7),
                    blurRadius: 16,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Center(
          child: value.isEmpty
              ? const SizedBox.shrink()
              : CustomPaint(
                  size: const Size(56, 56),
                  painter: value == 'X'
                      ? XPainter(color: color)
                      : OPainter(color: color),
                ),
        ),
      ),
    );
  }

  Color _colorFor(String v, bool win) {
    if (win) return Colors.greenAccent;
    if (v == 'X') return Colors.cyanAccent;
    if (v == 'O') return Colors.pinkAccent;
    return Colors.white;
  }
}

class XPainter extends CustomPainter {
  final Color color;
  const XPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final stroke = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset.zero, Offset(size.width, size.height), glow);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), glow);
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), stroke);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), stroke);
  }

  @override
  bool shouldRepaint(covariant XPainter old) => old.color != color;
}

class OPainter extends CustomPainter {
  final Color color;
  const OPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final stroke = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height).deflate(4);
    canvas.drawOval(rect, glow);
    canvas.drawOval(rect, stroke);
  }

  @override
  bool shouldRepaint(covariant OPainter old) => old.color != color;
}