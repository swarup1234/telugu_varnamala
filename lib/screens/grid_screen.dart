import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/letter.dart';
import '../services/progress_service.dart';
import '../widgets/letter_card.dart';
import 'detail_screen.dart';

class GridScreen extends StatefulWidget {
  final String type;
  const GridScreen({super.key, required this.type});

  @override
  State<GridScreen> createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  List<Letter> _letters = [];
  Set<String> _learned = {};
  final _progress = ProgressService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final json = await rootBundle.loadString('assets/data/letters.json');
    final all = (jsonDecode(json) as List).map((e) => Letter.fromJson(e)).toList();
    final learned = await _progress.getAllLearned();
    setState(() {
      _letters = all.where((l) => l.type == widget.type).toList()
        ..sort((a, b) => a.order.compareTo(b.order));
      _learned = learned;
    });
  }

  Future<void> _refreshLearned() async {
    final learned = await _progress.getAllLearned();
    setState(() => _learned = learned);
  }

  @override
  Widget build(BuildContext context) {
    final isVowel = widget.type == 'vowel';
    final title = isVowel ? 'అచ్చులు · Vowels' : 'హల్లులు · Consonants';
    final learnedCount = _letters.where((l) => _learned.contains(l.id)).length;
    final total = _letters.length;
    final progress = total == 0 ? 0.0 : learnedCount / total;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isVowel ? const Color(0xFF1565C0) : const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _letters.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Progress header
                Container(
                  color: isVowel ? const Color(0xFF1565C0) : const Color(0xFF2E7D32),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$learnedCount / $total learned',
                              style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          Text('${(progress * 100).round()}%',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _letters.length,
                    itemBuilder: (_, i) {
                      final letter = _letters[i];
                      return LetterCard(
                        letter: letter,
                        learned: _learned.contains(letter.id),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(
                                letters: _letters,
                                initialIndex: i,
                              ),
                            ),
                          );
                          await _refreshLearned();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
