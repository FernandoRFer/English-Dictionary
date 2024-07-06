class HistoryModel {
  int? id;
  String word;
  int dateTime;
  HistoryModel({
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

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? 0,
      word: json['word'] ?? "",
      dateTime: json['dateTime'] ?? 0,
    );
  }
}
