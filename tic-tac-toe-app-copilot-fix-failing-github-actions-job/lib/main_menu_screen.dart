import 'package:flutter/material.dart';
import 'package:neon_tic_tac_toe/game_screen.dart';
import 'package:neon_tic_tac_toe/rock_paper_scissors_screen.dart';
import 'package:neon_tic_tac_toe/memory_match_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Advanced Neon Logo
              const NeonGameCenterLogo(),
              const SizedBox(height: 30),
              
              // Game options
              _buildGameCard(
                context,
                title: 'TIC TAC TOE',
                subtitle: 'Classic 3x3 grid game',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameScreen(),
                  ),
                ),
                color: Colors.cyan,
              ),
              
              const SizedBox(height: 20),
              
              _buildGameCard(
                context,
                title: 'ROCK PAPER SCISSORS',
                subtitle: 'Classic hand game',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RockPaperScissorsScreen(),
                  ),
                ),
                color: Colors.pink,
              ),
              
              const SizedBox(height: 20),
              
              _buildGameCard(
                context,
                title: 'MEMORY MATCH',
                subtitle: 'Find matching pairs',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MemoryMatchScreen(),
                  ),
                ),
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDisabled ? Colors.grey : color,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDisabled ? Colors.grey : color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: isDisabled ? Colors.grey : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NeonGameCenterLogo extends StatefulWidget {
  const NeonGameCenterLogo({super.key});

  @override
  State<NeonGameCenterLogo> createState() => _NeonGameCenterLogoState();
}

class _NeonGameCenterLogoState extends State<NeonGameCenterLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.purple.withValues(alpha: 0.1),
                Colors.blue.withValues(alpha: 0.1),
                Colors.cyan.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.cyan.withValues(alpha: _glowAnimation.value * 0.7),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withValues(alpha: _glowAnimation.value * 0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Colors.purple.withValues(alpha: _glowAnimation.value * 0.3),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Custom neon game controller icon
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.gamepad,
                    size: 80,
                    color: Colors.transparent,
                  ),
                  CustomPaint(
                    size: const Size(80, 80),
                    painter: GameControllerPainter(
                      glowIntensity: _glowAnimation.value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Main title with gradient
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.cyan, Colors.blue, Colors.purple],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: Text(
                  'NEON GAME CENTER',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.cyan.withValues(alpha: _glowAnimation.value * 0.8),
                        blurRadius: 15,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                'PLAY • WIN • SHINE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 3,
                  shadows: [
                    Shadow(
                      color: Colors.pink.withValues(alpha: _glowAnimation.value * 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GameControllerPainter extends CustomPainter {
  final double glowIntensity;

  GameControllerPainter({required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Draw controller body with glow
    paint
      ..color = Colors.cyan
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5 * glowIntensity);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 60, height: 40),
        const Radius.circular(10),
      ),
      paint,
    );

    // Draw buttons with glow
    paint
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 * glowIntensity);
    
    // Left button
    canvas.drawCircle(
      center - const Offset(15, 0),
      5,
      paint..color = Colors.pink,
    );
    
    // Right button
    canvas.drawCircle(
      center - const Offset(-15, 0),
      5,
      paint..color = Colors.pink,
    );
    
    // Top button
    canvas.drawCircle(
      center - const Offset(0, -10),
      5,
      paint..color = Colors.purple,
    );
    
    // Bottom button
    canvas.drawCircle(
      center - const Offset(0, 10),
      5,
      paint..color = Colors.purple,
    );
    
    // Center button
    canvas.drawCircle(
      center,
      7,
      paint..color = Colors.blue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}