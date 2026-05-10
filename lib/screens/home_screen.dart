import 'package:flutter/material.dart';
import 'grid_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6F00), Color(0xFFFFB300)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 48),
              // Hero header
              const Text('తెలుగు వర్ణమాల',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              const Text('Telugu Varnamala · Learn the Alphabet',
                  style: TextStyle(fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 48),
              // Cards
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    children: [
                      _MenuCard(
                        label: 'అచ్చులు',
                        sublabel: 'Vowels · 16 letters',
                        icon: Icons.record_voice_over_rounded,
                        gradient: const LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF1565C0)]),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const GridScreen(type: 'vowel'))),
                      ),
                      const SizedBox(height: 16),
                      _MenuCard(
                        label: 'హల్లులు',
                        sublabel: 'Consonants · 36 letters',
                        icon: Icons.abc_rounded,
                        gradient: const LinearGradient(colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)]),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const GridScreen(type: 'consonant'))),
                      ),
                      const SizedBox(height: 16),
                      _MenuCard(
                        label: 'Quiz',
                        sublabel: 'Test your knowledge',
                        icon: Icons.quiz_rounded,
                        gradient: const LinearGradient(colors: [Color(0xFFAB47BC), Color(0xFF6A1B9A)]),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const QuizScreen())),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _MenuCard({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: gradient.colors.last.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 6)),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(sublabel, style: const TextStyle(fontSize: 13, color: Colors.white70)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 18),
          ],
        ),
      ),
    );
  }
}
