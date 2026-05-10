import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/letter.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';

class DetailScreen extends StatefulWidget {
  final List<Letter> letters;
  final int initialIndex;

  const DetailScreen({
    super.key,
    required this.letters,
    required this.initialIndex,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final PageController _pageController;
  late int _currentIndex;
  final _audio = AudioService();
  final _progress = ProgressService();
  final Set<String> _learnedIds = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _onPageChanged(widget.initialIndex, autoPlay: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audio.dispose();
    super.dispose();
  }

  Future<void> _onPageChanged(int index, {bool autoPlay = false}) async {
    setState(() => _currentIndex = index);
    final letter = widget.letters[index];
    await _progress.markLearned(letter.id);
    final learned = await _progress.getAllLearned();
    if (mounted) {
      setState(() {
        _learnedIds
          ..clear()
          ..addAll(learned);
      });
    }
    if (autoPlay || true) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _audio.play(letter.audioFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.letters.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: Text(
          '${_currentIndex + 1} / $total',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          if (_learnedIds.contains(widget.letters[_currentIndex].id))
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.star_rounded, color: Colors.amber),
            ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: total,
        onPageChanged: (i) => _onPageChanged(i),
        itemBuilder: (_, i) => _LetterPage(
          letter: widget.letters[i],
          onPlaySound: () => _audio.play(widget.letters[i].audioFile),
        ),
      ),
    );
  }
}

class _LetterPage extends StatelessWidget {
  final Letter letter;
  final VoidCallback onPlaySound;

  const _LetterPage({required this.letter, required this.onPlaySound});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            // Letter + romanisation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6F00), Color(0xFFFFB300)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.orange.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                children: [
                  Text(letter.letter,
                      style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(letter.roman,
                      style: const TextStyle(fontSize: 22, color: Colors.white70, letterSpacing: 2)),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Illustration
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SvgPicture.asset(
                  'assets/images/${letter.imageFile.replaceAll('.png', '.svg')}',
                  fit: BoxFit.contain,
                  placeholderBuilder: (_) =>
                      const Icon(Icons.image_rounded, size: 80, color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Word card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Text(letter.wordTelugu,
                      style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(letter.wordEnglish,
                      style: const TextStyle(fontSize: 20, color: Colors.grey)),
                  Text(letter.wordMeaning,
                      style: const TextStyle(fontSize: 15, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Play button
            ElevatedButton.icon(
              onPressed: onPlaySound,
              icon: const Icon(Icons.volume_up_rounded, size: 26),
              label: const Text('Play Sound', style: TextStyle(fontSize: 17)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 4,
              ),
            ),
            const SizedBox(height: 16),
            // Swipe hint
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chevron_left, color: Colors.grey),
                Text(' swipe to navigate ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
