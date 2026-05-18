import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_enrichment.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_model.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/transformers/external_character_import_transformer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExternalCharacterImportTransformer', () {
    const transformer = ExternalCharacterImportTransformer();

    test('transforms external character data into internal character model', () {
      const source = ExternalCharacterImportModel(
        malId: 13,
        name: 'Sasuke Uchiha',
        nameKanji: 'うちはサスケ',
        nicknames: ['Sasuke-kun'],
        favorites: 52745,
        about: 'Rival character',
        mainPicture: 'https://cdn.example.com/sasuke.jpg',
        url: 'https://myanimelist.net/character/13/Sasuke_Uchiha',
      );
      const enrichment = ExternalCharacterImportEnrichment(
        series: 'Naruto',
        tags: ['black_hair', 'uses_sword', 'has_tragic_past'],
        difficulty: DifficultyLevel.medium,
      );

      final result = transformer.transform(
        source: source,
        enrichment: enrichment,
      );

      expect(result.id, 'sasuke_uchiha');
      expect(result.series, 'Naruto');
      expect(result.tags, ['black_hair', 'uses_sword', 'has_tragic_past']);
      expect(result.difficulty, DifficultyLevel.medium);
      expect(result.popularity, 9);
      expect(result.image, isNull);
    });

    test('normalizes ids and lower popularity ranges safely', () {
      expect(transformer.buildId('Monkey D. Luffy'), 'monkey_d_luffy');
      expect(transformer.normalizePopularity(0), 1);
      expect(transformer.normalizePopularity(250), 3);
      expect(transformer.normalizePopularity(120000), 10);
    });
  });
}
