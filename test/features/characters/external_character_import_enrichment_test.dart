import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_enrichment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExternalCharacterImportEnrichment', () {
    test('parses optional metadata fields', () {
      final enrichment = ExternalCharacterImportEnrichment.fromJson({
        'series': 'Naruto',
        'animeMalId': 20,
        'tags': ['black_hair', 'uses_sword'],
        'difficulty': 'medium',
        'aliases': ['Sasuke-kun'],
        'sourceReference': 'https://myanimelist.net/character/13/Sasuke_Uchiha',
        'importNotes': 'Prototype enrichment.',
        'image': null,
      });

      expect(enrichment.series, 'Naruto');
      expect(enrichment.animeMalId, 20);
      expect(enrichment.tags, ['black_hair', 'uses_sword']);
      expect(enrichment.difficulty, DifficultyLevel.medium);
      expect(enrichment.aliases, ['Sasuke-kun']);
      expect(enrichment.sourceReference, contains('myanimelist.net'));
      expect(enrichment.importNotes, 'Prototype enrichment.');
    });

    test('uses safe defaults for optional enrichment metadata', () {
      final enrichment = ExternalCharacterImportEnrichment.fromJson({
        'series': 'Unknown',
        'tags': <String>[],
      });

      expect(enrichment.difficulty, DifficultyLevel.easy);
      expect(enrichment.animeMalId, isNull);
      expect(enrichment.aliases, isEmpty);
      expect(enrichment.sourceReference, isNull);
      expect(enrichment.importNotes, isNull);
      expect(enrichment.image, isNull);
    });
  });
}
