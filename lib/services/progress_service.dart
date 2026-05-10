import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _prefix = 'learned_';

  Future<bool> isLearned(String letterId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefix$letterId') ?? false;
  }

  Future<void> markLearned(String letterId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$letterId', true);
  }

  Future<Set<String>> getAllLearned() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs
        .getKeys()
        .where((k) => k.startsWith(_prefix))
        .map((k) => k.replaceFirst(_prefix, ''))
        .toSet();
  }
}
