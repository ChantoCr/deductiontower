import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_enrichment.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_model.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';

class ExternalCharacterImportTransformer {
  const ExternalCharacterImportTransformer();

  CharacterModel transform({
    required ExternalCharacterImportModel source,
    required ExternalCharacterImportEnrichment enrichment,
  }) {
    return CharacterModel(
      id: _buildId(source.name),
      name: source.name,
      series: enrichment.series,
      image: enrichment.image,
      tags: enrichment.tags,
      difficulty: enrichment.difficulty,
      popularity: _normalizePopularity(source.favorites),
    );
  }

  int normalizePopularity(int favorites) => _normalizePopularity(favorites);

  String buildId(String name) => _buildId(name);

  String _buildId(String name) {
    final lowerCased = name.toLowerCase();
    final normalized = lowerCased
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    return normalized.isEmpty ? 'imported_character' : normalized;
  }

  int _normalizePopularity(int favorites) {
    if (favorites >= 100000) {
      return 10;
    }
    if (favorites >= 50000) {
      return 9;
    }
    if (favorites >= 25000) {
      return 8;
    }
    if (favorites >= 10000) {
      return 7;
    }
    if (favorites >= 5000) {
      return 6;
    }
    if (favorites >= 1000) {
      return 5;
    }
    if (favorites >= 500) {
      return 4;
    }
    if (favorites >= 100) {
      return 3;
    }
    if (favorites > 0) {
      return 2;
    }

    return 1;
  }
}
