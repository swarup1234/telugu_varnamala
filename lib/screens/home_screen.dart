import 'package:flutter/material.dart';
import 'grid_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('తెలుగు వర్ణమాల', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Telugu Varnamala',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            const Text(
              'Learn Telugu Alphabet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            _MenuButton(
              label: 'అచ్చులు · Vowels',
              subtitle: '16 letters',
              icon: Icons.record_voice_over,
              color: Colors.blue,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => const GridScreen(type: 'vowel'),
              )),
            ),
            const SizedBox(height: 16),
            _MenuButton(
              label: 'హల్లులు · Consonants',
              subtitle: '36 letters',
              icon: Icons.abc,
              color: Colors.green,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => const GridScreen(type: 'consonant'),
              )),
            ),
            const SizedBox(height: 16),
            _MenuButton(
              label: 'Quiz',
              subtitle: 'Test your knowledge',
              icon: Icons.quiz,
              color: Colors.purple,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => const QuizScreen(),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }
}
