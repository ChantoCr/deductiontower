import 'dart:convert';

import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/character_import_validation_issue.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_anime_import_model.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_enrichment.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_model.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_preview_report.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_review_entry.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/services/external_character_tag_suggestion_service.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/transformers/external_character_import_transformer.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';

class ExternalCharacterImportPreviewService {
  const ExternalCharacterImportPreviewService({
    this.transformer = const ExternalCharacterImportTransformer(),
    this.tagSuggestionService = const ExternalCharacterTagSuggestionService(),
  });

  final ExternalCharacterImportTransformer transformer;
  final ExternalCharacterTagSuggestionService tagSuggestionService;

  ExternalCharacterImportPreviewReport buildPreviewReport({
    required List<ExternalCharacterImportModel> sourceCharacters,
    required Map<int, ExternalCharacterImportEnrichment> enrichments,
    required Set<String> allowedTagIds,
    Map<int, ExternalAnimeImportModel> animeSeriesByMalId = const {},
  }) {
    final previewModels = <CharacterModel>[];
    final issues = <CharacterImportValidationIssue>[];
    final reviewQueue = <ExternalCharacterImportReviewEntry>[];
    final duplicateSourceMalIds = _findDuplicateSourceMalIds(sourceCharacters);
    final seenTransformedIds = <String>{};

    for (final sourceCharacter in sourceCharacters) {
      final characterIssues = <CharacterImportValidationIssue>[];
      final enrichment = enrichments[sourceCharacter.malId];

      if (duplicateSourceMalIds.contains(sourceCharacter.malId)) {
        characterIssues.add(
          CharacterImportValidationIssue(
            code: 'duplicate_source_mal_id',
            message:
                'Duplicate external source mal_id detected: ${sourceCharacter.malId} (${sourceCharacter.name}).',
            sourceMalId: sourceCharacter.malId,
            characterName: sourceCharacter.name,
          ),
        );
      }

      if (enrichment == null) {
        characterIssues.add(
          CharacterImportValidationIssue(
            code: 'missing_enrichment',
            message:
                'Missing enrichment for external character ${sourceCharacter.malId} (${sourceCharacter.name}).',
            sourceMalId: sourceCharacter.malId,
            characterName: sourceCharacter.name,
          ),
        );
      }

      CharacterModel? transformedCharacter;
      String? resolvedSeries;
      String? animeSeriesTitle;
      String? seriesResolutionSource;
      List<String> reviewTags = const [];
      List<String> reviewAliases = const [];
      String? sourceReference;
      int? animeMalId;
      DifficultyLevel? difficulty;

      if (enrichment != null) {
        reviewTags = enrichment.tags;
        reviewAliases = enrichment.aliases;
        sourceReference = enrichment.sourceReference ?? sourceCharacter.url;
        animeMalId = enrichment.animeMalId;
        difficulty = enrichment.difficulty;

        _validateTags(
          sourceCharacter: sourceCharacter,
          enrichment: enrichment,
          allowedTagIds: allowedTagIds,
          issues: characterIssues,
        );

        final seriesInfo = _resolveSeriesInfo(
          sourceCharacter: sourceCharacter,
          enrichment: enrichment,
          animeSeriesByMalId: animeSeriesByMalId,
          issues: characterIssues,
        );

        resolvedSeries = seriesInfo.resolvedSeries;
        animeSeriesTitle = seriesInfo.animeSeriesTitle;
        seriesResolutionSource = seriesInfo.resolutionSource;

        transformedCharacter = transformer.transform(
          source: sourceCharacter,
          enrichment: enrichment,
          seriesOverride: resolvedSeries,
        );

        if (!seenTransformedIds.add(transformedCharacter.id)) {
          characterIssues.add(
            CharacterImportValidationIssue(
              code: 'duplicate_transformed_id',
              message:
                  'Duplicate transformed character id detected during import: ${transformedCharacter.id}.',
              sourceMalId: sourceCharacter.malId,
              characterName: sourceCharacter.name,
              characterId: transformedCharacter.id,
            ),
          );
        }
      }

      final suggestedTags = tagSuggestionService.suggestTags(
        about: sourceCharacter.about,
        allowedTagIds: allowedTagIds,
        excludedTagIds: reviewTags.toSet(),
      );

      if (transformedCharacter != null && !characterIssues.any((issue) => issue.isBlocking)) {
        previewModels.add(transformedCharacter);
      }

      issues.addAll(characterIssues);
      reviewQueue.add(
        ExternalCharacterImportReviewEntry(
          malId: sourceCharacter.malId,
          name: sourceCharacter.name,
          animeMalId: animeMalId,
          transformedId: transformedCharacter?.id,
          resolvedSeries: resolvedSeries,
          animeSeriesTitle: animeSeriesTitle,
          seriesResolutionSource: seriesResolutionSource,
          tags: reviewTags,
          suggestedTags: suggestedTags,
          difficulty: difficulty,
          aliases: reviewAliases,
          sourceReference: sourceReference,
          issues: characterIssues,
        ),
      );
    }

    return ExternalCharacterImportPreviewReport(
      previewModels: previewModels,
      issues: issues,
      reviewQueue: reviewQueue,
    );
  }

  List<CharacterModel> generatePreviewModels({
    required List<ExternalCharacterImportModel> sourceCharacters,
    required Map<int, ExternalCharacterImportEnrichment> enrichments,
    required Set<String> allowedTagIds,
    Map<int, ExternalAnimeImportModel> animeSeriesByMalId = const {},
  }) {
    final report = buildPreviewReport(
      sourceCharacters: sourceCharacters,
      enrichments: enrichments,
      allowedTagIds: allowedTagIds,
      animeSeriesByMalId: animeSeriesByMalId,
    );

    if (report.hasBlockingIssues) {
      throw StateError(report.issues.first.message);
    }

    return report.previewModels;
  }

  List<Map<String, dynamic>> generatePreviewJsonList({
    required List<ExternalCharacterImportModel> sourceCharacters,
    required Map<int, ExternalCharacterImportEnrichment> enrichments,
    required Set<String> allowedTagIds,
    Map<int, ExternalAnimeImportModel> animeSeriesByMalId = const {},
  }) {
    return generatePreviewModels(
      sourceCharacters: sourceCharacters,
      enrichments: enrichments,
      allowedTagIds: allowedTagIds,
      animeSeriesByMalId: animeSeriesByMalId,
    ).map((character) => character.toJson()).toList();
  }

  String generatePreviewJsonString({
    required List<ExternalCharacterImportModel> sourceCharacters,
    required Map<int, ExternalCharacterImportEnrichment> enrichments,
    required Set<String> allowedTagIds,
    Map<int, ExternalAnimeImportModel> animeSeriesByMalId = const {},
  }) {
    final jsonList = generatePreviewJsonList(
      sourceCharacters: sourceCharacters,
      enrichments: enrichments,
      allowedTagIds: allowedTagIds,
      animeSeriesByMalId: animeSeriesByMalId,
    );

    return const JsonEncoder.withIndent('  ').convert(jsonList);
  }

  String generateReviewQueueJsonString({
    required List<ExternalCharacterImportModel> sourceCharacters,
    required Map<int, ExternalCharacterImportEnrichment> enrichments,
    required Set<String> allowedTagIds,
    Map<int, ExternalAnimeImportModel> animeSeriesByMalId = const {},
  }) {
    final report = buildPreviewReport(
      sourceCharacters: sourceCharacters,
      enrichments: enrichments,
      allowedTagIds: allowedTagIds,
      animeSeriesByMalId: animeSeriesByMalId,
    );

    final jsonList = report.reviewQueue.map((entry) => entry.toJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(jsonList);
  }

  Set<int> _findDuplicateSourceMalIds(List<ExternalCharacterImportModel> sourceCharacters) {
    final counts = <int, int>{};

    for (final sourceCharacter in sourceCharacters) {
      counts.update(sourceCharacter.malId, (count) => count + 1, ifAbsent: () => 1);
    }

    return counts.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .toSet();
  }

  _ResolvedSeriesInfo _resolveSeriesInfo({
    required ExternalCharacterImportModel sourceCharacter,
    required ExternalCharacterImportEnrichment enrichment,
    required Map<int, ExternalAnimeImportModel> animeSeriesByMalId,
    required List<CharacterImportValidationIssue> issues,
  }) {
    final explicitSeries = enrichment.series.trim();
    final animeMalId = enrichment.animeMalId;
    final anime = animeMalId == null ? null : animeSeriesByMalId[animeMalId];
    final animeSeriesTitle = anime?.displayTitle;

    if (animeMalId != null && anime == null) {
      issues.add(
        CharacterImportValidationIssue(
          code: 'missing_anime_series_reference',
          message:
              'Missing anime series reference ${enrichment.animeMalId} for external character ${sourceCharacter.malId} (${sourceCharacter.name}).',
          isBlocking: false,
          sourceMalId: sourceCharacter.malId,
          characterName: sourceCharacter.name,
        ),
      );
    }

    if (explicitSeries.isNotEmpty && explicitSeries.toLowerCase() != 'unknown') {
      if (animeSeriesTitle != null && !_seriesLabelsMatch(explicitSeries, animeSeriesTitle)) {
        issues.add(
          CharacterImportValidationIssue(
            code: 'series_mismatch',
            message:
                'Series mismatch for external character ${sourceCharacter.malId} (${sourceCharacter.name}): enrichment series "$explicitSeries" differs from anime lookup "$animeSeriesTitle".',
            isBlocking: false,
            sourceMalId: sourceCharacter.malId,
            characterName: sourceCharacter.name,
          ),
        );
      }

      return _ResolvedSeriesInfo(
        resolvedSeries: explicitSeries,
        animeSeriesTitle: animeSeriesTitle,
        resolutionSource: 'enrichment',
      );
    }

    if (animeSeriesTitle != null) {
      return _ResolvedSeriesInfo(
        resolvedSeries: animeSeriesTitle,
        animeSeriesTitle: animeSeriesTitle,
        resolutionSource: 'anime_lookup',
      );
    }

    return const _ResolvedSeriesInfo(
      resolvedSeries: 'Unknown',
      resolutionSource: 'fallback',
    );
  }

  bool _seriesLabelsMatch(String left, String right) {
    return _normalizeSeriesLabel(left) == _normalizeSeriesLabel(right);
  }

  String _normalizeSeriesLabel(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '')
        .trim();
  }

  void _validateTags({
    required ExternalCharacterImportModel sourceCharacter,
    required ExternalCharacterImportEnrichment enrichment,
    required Set<String> allowedTagIds,
    required List<CharacterImportValidationIssue> issues,
  }) {
    for (final tag in enrichment.tags) {
      if (!allowedTagIds.contains(tag)) {
        issues.add(
          CharacterImportValidationIssue(
            code: 'invalid_tag',
            message:
                'Invalid tag "$tag" for external character ${sourceCharacter.malId} (${sourceCharacter.name}).',
            sourceMalId: sourceCharacter.malId,
            characterName: sourceCharacter.name,
            tagId: tag,
          ),
        );
      }
    }
  }
}

class _ResolvedSeriesInfo {
  const _ResolvedSeriesInfo({
    required this.resolvedSeries,
    required this.resolutionSource,
    this.animeSeriesTitle,
  });

  final String resolvedSeries;
  final String? animeSeriesTitle;
  final String resolutionSource;
}
