class Letter {
  final String id;
  final String letter;
  final String roman;
  final String wordTelugu;
  final String wordEnglish;
  final String wordMeaning;
  final String audioFile;
  final String imageFile;
  final String type;
  final int order;

  Letter({
    required this.id,
    required this.letter,
    required this.roman,
    required this.wordTelugu,
    required this.wordEnglish,
    required this.wordMeaning,
    required this.audioFile,
    required this.imageFile,
    required this.type,
    required this.order,
  });

  factory Letter.fromJson(Map<String, dynamic> json) => Letter(
        id: json['id'],
        letter: json['letter'],
        roman: json['roman'],
        wordTelugu: json['word_telugu'],
        wordEnglish: json['word_english'],
        wordMeaning: json['word_meaning'],
        audioFile: json['audio_file'],
        imageFile: json['image_file'],
        type: json['type'],
        order: json['order'],
      );

  bool get isVowel => type == 'vowel';
}
