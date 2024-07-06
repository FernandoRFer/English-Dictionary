class FavoritesModel {
  int? id;
  String word;
  int dateTime;
  FavoritesModel({
    this.id,
    required this.word,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'dateTime': dateTime,
    };
  }

  factory FavoritesModel.fromJson(Map<String, dynamic> json) {
    return FavoritesModel(
      id: json['id'] ?? 0,
      word: json['word'] ?? "",
      dateTime: json['dateTime'] ?? 0,
    );
  }
}
