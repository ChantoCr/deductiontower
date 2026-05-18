import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExternalCharacterImportModel', () {
    test('parses external MAL/Jikan-style json', () {
      final model = ExternalCharacterImportModel.fromJson({
        'mal_id': 13,
        'name': 'Sasuke Uchiha',
        'name_kanji': 'うちはサスケ',
        'nicknames': ['Sasuke-kun'],
        'favorites': 52745,
        'about': 'Rival character',
        'main_picture': 'https://cdn.example.com/sasuke.jpg',
        'url': 'https://myanimelist.net/character/13/Sasuke_Uchiha',
      });

      expect(model.malId, 13);
      expect(model.name, 'Sasuke Uchiha');
      expect(model.nicknames, ['Sasuke-kun']);
      expect(model.favorites, 52745);
      expect(model.url, contains('myanimelist.net'));
    });

    test('uses safe defaults for optional fields', () {
      final model = ExternalCharacterImportModel.fromJson({
        'mal_id': 5,
        'name': 'Monkey D. Luffy',
      });

      expect(model.nicknames, isEmpty);
      expect(model.favorites, 0);
      expect(model.about, isNull);
      expect(model.mainPicture, isNull);
      expect(model.url, isNull);
    });
  });
}
