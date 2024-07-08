class WordModel {
  final int id;
  final String word;

  WordModel({
    required this.id,
    required this.word,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'] ?? 0,
      word: json['word'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
    };
  }
}
