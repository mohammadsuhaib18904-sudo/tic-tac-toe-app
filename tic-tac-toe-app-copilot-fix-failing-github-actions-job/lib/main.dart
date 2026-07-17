import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:neon_tic_tac_toe/game_screen.dart';
import 'package:neon_tic_tac_toe/rock_paper_scissors_screen.dart';
import 'package:neon_tic_tac_toe/memory_match_screen.dart';
import 'package:neon_tic_tac_toe/valentines_screen.dart';
import 'package:neon_tic_tac_toe/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  final settings = SettingsProvider();
  await settings.load();
  runApp(
    ChangeNotifierProvider.value(
      value: settings,
      child: const NeonGameCenterApp(),
    ),
  );
}

class NeonGameCenterApp extends StatelessWidget {
  const NeonGameCenterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neon Game Center',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.cyan,
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyan,
          secondary: Colors.pink,
          surface: Colors.black,
        ),
        textTheme: const TextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _tabs = <_TabSpec>[
    _TabSpec(label: 'Tic Tac Toe', color: Colors.cyan, icon: Icons.grid_3x3),
    _TabSpec(
      label: 'R P S',
      color: Colors.pink,
      icon: Icons.content_cut,
    ),
    _TabSpec(
      label: 'Memory',
      color: Colors.purple,
      icon: Icons.psychology,
    ),
    _TabSpec(
      label: 'Valentine',
      color: Colors.redAccent,
      icon: Icons.favorite,
    ),
  ];

  Widget _bodyFor(int i) {
    switch (i) {
      case 0:
        return const GameScreen();
      case 1:
        return const RockPaperScissorsScreen();
      case 2:
        return const MemoryMatchScreen();
      case 3:
        return const ValentinesScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final spec = _tabs[_index];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: NeonAppBarTitle(text: spec.label.toUpperCase(), color: spec.color),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: _bodyFor(_index),
        ),
      ),
      bottomNavigationBar: settings.leftHandedMode
          ? _buildNavBar(spec.color, reverse: true)
          : _buildNavBar(spec.color),
    );
  }

  Widget _buildNavBar(Color activeColor, {bool reverse = false}) {
    final items = _tabs
        .map(
          (t) => BottomNavigationBarItem(
            icon: Icon(t.icon, color: t.color),
            activeIcon: Icon(t.icon, color: t.color),
            label: t.label,
          ),
        )
        .toList();
    final ordered = reverse ? items.reversed.toList() : items;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: activeColor.withValues(alpha: 0.4), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: activeColor.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (i) {
          setState(() => _index = reverse ? _tabs.length - 1 - i : i);
        },
        selectedItemColor: activeColor,
        unselectedItemColor: Colors.white54,
        showUnselectedLabels: true,
        items: ordered,
      ),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _SettingsSheet(),
    );
  }
}

class _TabSpec {
  final String label;
  final Color color;
  final IconData icon;
  const _TabSpec({required this.label, required this.color, required this.icon});
}

class NeonAppBarTitle extends StatelessWidget {
  final String text;
  final Color color;
  const NeonAppBarTitle({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 2,
        shadows: [
          Shadow(color: color.withValues(alpha: 0.9), blurRadius: 12),
          Shadow(color: color.withValues(alpha: 0.5), blurRadius: 24),
        ],
      ),
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'SETTINGS',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              value: settings.leftHandedMode,
              onChanged: (_) => settings.toggleLeftHanded(),
              title: const Text('Left-handed Mode',
                  style: TextStyle(color: Colors.white)),
              activeColor: Colors.cyan,
            ),
            SwitchListTile(
              value: settings.hapticsEnabled,
              onChanged: (_) => settings.toggleHaptics(),
              title: const Text('Haptic Feedback',
                  style: TextStyle(color: Colors.white)),
              activeColor: Colors.pink,
            ),
            SwitchListTile(
              value: settings.soundEnabled,
              onChanged: (_) => settings.toggleSound(),
              title: const Text('Sound Effects',
                  style: TextStyle(color: Colors.white)),
              activeColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}