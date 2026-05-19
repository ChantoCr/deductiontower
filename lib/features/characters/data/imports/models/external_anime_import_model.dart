class ExternalAnimeImportModel {
  const ExternalAnimeImportModel({
    required this.malId,
    required this.title,
    this.titleEnglish,
    this.titleJapanese,
    this.url,
  });

  factory ExternalAnimeImportModel.fromJson(Map<String, dynamic> json) {
    return ExternalAnimeImportModel(
      malId: json['mal_id'] as int,
      title: json['title'] as String,
      titleEnglish: json['title_english'] as String?,
      titleJapanese: json['title_japanese'] as String?,
      url: json['url'] as String?,
    );
  }

  final int malId;
  final String title;
  final String? titleEnglish;
  final String? titleJapanese;
  final String? url;

  String get displayTitle {
    final englishTitle = titleEnglish?.trim();
    if (englishTitle != null && englishTitle.isNotEmpty) {
      return englishTitle;
    }

    return title;
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': malId,
      'title': title,
      'title_english': titleEnglish,
      'title_japanese': titleJapanese,
      'url': url,
    };
  }
}
