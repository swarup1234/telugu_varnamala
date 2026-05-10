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

  @override
  Widget build(BuildContext context) {
    final title = widget.type == 'vowel' ? 'అచ్చులు · Vowels' : 'హల్లులు · Consonants';
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _letters.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
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
                    await Navigator.push(context, MaterialPageRoute(
                      builder: (_) => DetailScreen(letter: letter),
                    ));
                    final learned = await _progress.getAllLearned();
                    setState(() => _learned = learned);
                  },
                );
              },
            ),
    );
  }
}
