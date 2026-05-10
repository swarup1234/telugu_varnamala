import 'package:flutter/material.dart';
import '../models/letter.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: learned ? Colors.amber.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: learned ? Colors.amber : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                letter.letter,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            if (learned)
              const Positioned(
                top: 4,
                right: 4,
                child: Icon(Icons.star, color: Colors.amber, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}
