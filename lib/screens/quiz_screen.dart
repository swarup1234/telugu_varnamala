import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import '../models/letter.dart';
import '../services/audio_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Letter> _all = [];
  late Letter _correct;
  late List<Letter> _options;
  String? _selected;
  int _score = 0;
  int _total = 0;
  final _audio = AudioService();
  late ConfettiController _confetti;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
    _loadAndNext();
  }

  @override
  void dispose() {
    _audio.dispose();
    _confetti.dispose();
    super.dispose();
  }

  Future<void> _loadAndNext() async {
    if (_all.isEmpty) {
      final json = await rootBundle.loadString('assets/data/letters.json');
      _all = (jsonDecode(json) as List).map((e) => Letter.fromJson(e)).toList();
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    final shuffled = List<Letter>.from(_all)..shuffle(_rng);
    _correct = shuffled.first;
    final wrong = shuffled.where((l) => l.id != _correct.id).take(3).toList();
    final opts = [_correct, ...wrong]..shuffle(_rng);
    setState(() {
      _options = opts;
      _selected = null;
    });
    Future.delayed(const Duration(milliseconds: 300), () => _audio.play(_correct.audioFile));
  }

  void _onAnswer(Letter letter) {
    if (_selected != null) return;
    final correct = letter.id == _correct.id;
    setState(() {
      _selected = letter.id;
      _total++;
      if (correct) {
        _score++;
        _confetti.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_all.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('$_score / $_total', style: const TextStyle(fontSize: 18))),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text('Which letter do you hear?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _audio.play(_correct.audioFile),
                  icon: const Icon(Icons.volume_up, size: 32),
                  label: const Text('Play Sound', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                const SizedBox(height: 40),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: _options.map((l) {
                    Color bg = Colors.white;
                    if (_selected != null) {
                      if (l.id == _correct.id) { bg = Colors.green.shade200; }
                      else if (l.id == _selected) { bg = Colors.red.shade200; }
                    }
                    return GestureDetector(
                      onTap: () => _onAnswer(l),
                      child: Container(
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                        ),
                        child: Center(
                          child: Text(l.letter,
                              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                if (_selected != null)
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Next', style: TextStyle(fontSize: 18)),
                  ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
            ),
          ),
        ],
      ),
    );
  }
}
