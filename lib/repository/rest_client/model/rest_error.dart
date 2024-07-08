class RestError {
  final String message;
  final String title;
  final String resolution;

  RestError.fromJson(Map<String, dynamic> json)
      : message = json['message'] ?? "",
        title = json['title'] ?? "",
        resolution = json['resolution'] ?? "";
  @override
  String toString() {
    return "Title: $title - Mensagem: $message - Resolution - $resolution";
  }
}
