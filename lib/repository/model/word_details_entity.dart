class WordDetailsEntity {
  String word;
  String phonetic;
  String origin;
  final List<Phonetics> phonetics;
  final List<Meanings> meanings;

  WordDetailsEntity(
      {required this.word,
      required this.phonetic,
      required this.origin,
      required this.phonetics,
      required this.meanings});

  factory WordDetailsEntity.fromJson(Map<String, dynamic> json) {
    return WordDetailsEntity(
        word: json['word'] ?? "",
        phonetic: json['phonetic'] ?? "",
        origin: json['origin'] ?? "",
        phonetics: json['phonetics'] != null
            ? ((json['phonetics'] as List)
                .map((e) => Phonetics.fromJson(e))
                .toList())
            : [],
        meanings: json['meanings'] != null
            ? ((json['meanings'] as List)
                .map((e) => Meanings.fromJson(e))
                .toList())
            : []);
  }

  // {
  //   word = json['word'];
  //   phonetic = json['phonetic'];
  //   origin = json['origin'] ?? "";
  //   if (json['phonetics'] != null) {
  //     json['phonetics'].forEach((v) {
  //       phonetics.add(Phonetics.fromJson(v));
  //     });
  //   }
  //   if (json['meanings'] != null) {
  //     json['meanings'].forEach((v) {
  //       meanings.add(Meanings.fromJson(v));
  //     });
  //   }
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['word'] = word;
    data['phonetic'] = phonetic;
    data['phonetics'] = phonetics.map((v) => v.toJson()).toList();
    data['origin'] = origin;
    data['meanings'] = meanings.map((v) => v.toJson()).toList();
    return data;
  }
}

class Phonetics {
  String text;
  String audio;

  Phonetics({required this.text, required this.audio});

  factory Phonetics.fromJson(Map<String, dynamic> json) {
    return Phonetics(text: json['text'] ?? "", audio: json['audio'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['audio'] = audio;
    return data;
  }
}

class Meanings {
  String partOfSpeech;
  List<Definitions> definitions;

  Meanings({
    required this.partOfSpeech,
    required this.definitions,
  });

  Meanings.fromJson(Map<String, dynamic> json)
      : partOfSpeech = json["partOfSpeech"] ?? "",
        definitions = json["definitions"] != null
            ? (json["definitions"] as List)
                .map((e) => Definitions.fromJson(e))
                .toList()
            : [];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['partOfSpeech'] = partOfSpeech;
    data['definitions'] = definitions.map((v) => v.toJson()).toList();
    return data;
  }
}

class Definitions {
  String definition;
  String example;
  List<dynamic>? synonyms;
  List<dynamic>? antonyms;

  Definitions(
      {required this.definition,
      required this.example,
      this.synonyms,
      this.antonyms});

  Definitions.fromJson(Map<String, dynamic> json)
      : definition = json['definition'] ?? "",
        example = json['example'] ?? "";

  Map<String, dynamic> toJson() {
    return {'definition': definition, 'example': example};
  }
}
