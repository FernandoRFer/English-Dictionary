class FavoritesModel {
  int? id;
  String searchWord;
  int dateTime;
  FavoritesModel({
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

  factory FavoritesModel.fromJson(Map<String, dynamic> json) {
    return FavoritesModel(
      id: json['id'] ?? 0,
      searchWord: json['searchWord'] ?? "",
      dateTime: json['dateTime'] ?? 0,
    );
  }
}
