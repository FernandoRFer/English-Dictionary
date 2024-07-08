import 'package:english_dictionary/repository/model/word_model.dart';

class HistoryModel extends WordModel {
  int dateTime;
  HistoryModel({
    required super.id,
    required super.word,
    required this.dateTime,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'dateTime': dateTime,
    };
  }

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? 0,
      word: json['word'] ?? "",
      dateTime: json['dateTime'] ?? 0,
    );
  }
}
