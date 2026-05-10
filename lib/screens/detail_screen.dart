import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/letter.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';

class DetailScreen extends StatefulWidget {
  final Letter letter;
  const DetailScreen({super.key, required this.letter});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _audio = AudioService();
  final _progress = ProgressService();
  bool _learned = false;

  @override
  void initState() {
    super.initState();
    _progress.isLearned(widget.letter.id).then((v) => setState(() => _learned = v));
    _progress.markLearned(widget.letter.id);
    Future.delayed(const Duration(milliseconds: 300), () => _audio.play(widget.letter.audioFile));
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.letter;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: Text(l.letter, style: const TextStyle(fontSize: 28)),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          if (_learned) const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.star, color: Colors.amber),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l.letter, style: const TextStyle(fontSize: 96, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(l.roman, style: const TextStyle(fontSize: 24, color: Colors.grey)),
              const SizedBox(height: 32),
              // Image placeholder (shows icon if image not found)
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SvgPicture.asset(
                    'assets/images/${l.imageFile.replaceAll('.png', '.svg')}',
                    width: 140,
                    height: 140,
                    placeholderBuilder: (_) => const Icon(Icons.image, size: 80, color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(l.wordTelugu, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Text(l.wordEnglish, style: const TextStyle(fontSize: 20, color: Colors.grey)),
              Text(l.wordMeaning, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _audio.play(l.audioFile),
                icon: const Icon(Icons.volume_up, size: 28),
                label: const Text('Play Sound', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
