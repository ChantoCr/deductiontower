class ExternalCharacterImportModel {
  const ExternalCharacterImportModel({
    required this.malId,
    required this.name,
    required this.nicknames,
    required this.favorites,
    this.nameKanji,
    this.about,
    this.mainPicture,
    this.url,
  });

  factory ExternalCharacterImportModel.fromJson(Map<String, dynamic> json) {
    return ExternalCharacterImportModel(
      malId: json['mal_id'] as int,
      name: json['name'] as String,
      nameKanji: json['name_kanji'] as String?,
      nicknames: (json['nicknames'] as List<dynamic>? ?? const []).cast<String>(),
      favorites: json['favorites'] as int? ?? 0,
      about: json['about'] as String?,
      mainPicture: json['main_picture'] as String?,
      url: json['url'] as String?,
    );
  }

  final int malId;
  final String name;
  final String? nameKanji;
  final List<String> nicknames;
  final int favorites;
  final String? about;
  final String? mainPicture;
  final String? url;

  Map<String, dynamic> toJson() {
    return {
      'mal_id': malId,
      'name': name,
      'name_kanji': nameKanji,
      'nicknames': nicknames,
      'favorites': favorites,
      'about': about,
      'main_picture': mainPicture,
      'url': url,
    };
  }
}
