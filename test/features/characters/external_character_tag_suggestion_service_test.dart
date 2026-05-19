import 'package:anime_deduction_tower/features/characters/data/imports/services/external_character_tag_suggestion_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExternalCharacterTagSuggestionService', () {
    const service = ExternalCharacterTagSuggestionService();

    test('suggests broader allowed tags from carefully matched external about text', () {
      final suggestions = service.suggestTags(
        about:
            'A black-haired lead character who wields a sword, transforms, and carries a tragic past.',
        allowedTagIds: {
          'black_hair',
          'protagonist',
          'uses_sword',
          'has_transformation',
          'has_tragic_past',
        },
      );

      expect(
        suggestions,
        ['black_hair', 'protagonist', 'uses_sword', 'has_transformation', 'has_tragic_past'],
      );
    });

    test('avoids common false positives for broad words like form and dark', () {
      final suggestions = service.suggestTags(
        about:
            'A strategist with a dark personality who takes a form of leadership in battle.',
        allowedTagIds: {'black_hair', 'has_transformation'},
      );

      expect(suggestions, isEmpty);
    });

    test('suggests newer descriptive tags like hero, young, fire, and speed', () {
      final suggestions = service.suggestTags(
        about: 'A young hero who uses fire with swift movements and immense strength.',
        allowedTagIds: {'hero', 'young', 'fire_user', 'fast', 'strong'},
      );

      expect(suggestions, ['hero', 'young', 'strong', 'fast', 'fire_user']);
    });

    test('does not suggest excluded or unsupported tags', () {
      final suggestions = service.suggestTags(
        about: 'A villain with several transformations.',
        allowedTagIds: {'villain', 'has_transformation'},
        excludedTagIds: {'villain'},
      );

      expect(suggestions, ['has_transformation']);
    });
  });
}
