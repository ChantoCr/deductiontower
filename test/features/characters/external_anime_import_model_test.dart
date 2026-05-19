import 'package:anime_deduction_tower/features/characters/data/imports/models/external_anime_import_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExternalAnimeImportModel', () {
    test('parses anime import json and prefers english display title when present', () {
      final model = ExternalAnimeImportModel.fromJson({
        'mal_id': 21,
        'title': 'One Piece',
        'title_english': 'One Piece',
        'title_japanese': 'ONE PIECE',
        'url': 'https://myanimelist.net/anime/21/One_Piece',
      });

      expect(model.malId, 21);
      expect(model.title, 'One Piece');
      expect(model.displayTitle, 'One Piece');
      expect(model.url, contains('myanimelist.net'));
    });

    test('falls back to base title when english title is missing', () {
      final model = ExternalAnimeImportModel.fromJson({
        'mal_id': 16498,
        'title': 'Shingeki no Kyojin',
      });

      expect(model.displayTitle, 'Shingeki no Kyojin');
    });
  });
}
