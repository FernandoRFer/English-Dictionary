class HistoryModel {
  int? id;
  String searchWord;
  int dateTime;
  HistoryModel({
    this.id,
    required this.searchWord,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'searchWord': searchWord,
      'dateTime': dateTime,
    };
  }

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? 0,
      searchWord: json['searchWord'] ?? "",
      dateTime: json['dateTime'] ?? 0,
    );
  }
}
