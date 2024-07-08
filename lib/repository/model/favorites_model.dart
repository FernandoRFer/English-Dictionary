import 'package:english_dictionary/repository/model/word_model.dart';

class FavoritesModel extends WordModel {
  int dateTime;
  FavoritesModel({
    required this.dateTime,
    required super.id,
    required super.word,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
