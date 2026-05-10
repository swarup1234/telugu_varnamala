import 'package:flutter/material.dart';
import '../models/letter.dart';

// Cycle through these card gradients
const _gradients = [
  [Color(0xFFFF8A65), Color(0xFFFF5722)],
  [Color(0xFF4FC3F7), Color(0xFF0288D1)],
  [Color(0xFF81C784), Color(0xFF388E3C)],
  [Color(0xFFFFD54F), Color(0xFFF9A825)],
  [Color(0xFFBA68C8), Color(0xFF7B1FA2)],
  [Color(0xFF4DB6AC), Color(0xFF00796B)],
  [Color(0xFFF06292), Color(0xFFC2185B)],
  [Color(0xFF64B5F6), Color(0xFF1565C0)],
];

class LetterCard extends StatelessWidget {
  final Letter letter;
  final bool learned;
  final VoidCallback onTap;

  const LetterCard({
    super.key,
    required this.letter,
    required this.learned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _gradients[letter.order % _gradients.length];
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: learned ? [colors[0], colors[1]] : [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: learned ? colors[1] : Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: learned ? colors[1].withValues(alpha: 0.35) : Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                letter.letter,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: learned ? Colors.white : Colors.black87,
                ),
              ),
            ),
            if (learned)
              const Positioned(
                top: 4,
                right: 4,
                child: Icon(Icons.star_rounded, color: Colors.white, size: 14),
              ),
          ],
        ),
      ),
    );
  }
}
