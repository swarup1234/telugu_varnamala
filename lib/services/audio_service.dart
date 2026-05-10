import 'package:just_audio/just_audio.dart';

class AudioService {
  final _player = AudioPlayer();

  Future<void> play(String audioFile) async {
    try {
      await _player.setAsset('assets/audio/$audioFile');
      await _player.play();
    } catch (_) {}
  }

  void dispose() => _player.dispose();
}
