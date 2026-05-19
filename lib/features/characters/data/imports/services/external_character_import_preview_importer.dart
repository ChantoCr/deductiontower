import 'package:anime_deduction_tower/features/characters/data/imports/datasources/local_external_character_import_datasource.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_preview_report.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/services/external_character_import_preview_service.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';

class ExternalCharacterImportPreviewImporter {
  ExternalCharacterImportPreviewImporter({
    LocalExternalCharacterImportDataSource? dataSource,
    ExternalCharacterImportPreviewService? previewService,
  }) : _dataSource = dataSource ?? LocalExternalCharacterImportDataSource(),
       _previewService = previewService ?? const ExternalCharacterImportPreviewService();

  final LocalExternalCharacterImportDataSource _dataSource;
  final ExternalCharacterImportPreviewService _previewService;

  Future<ExternalCharacterImportPreviewReport> generatePreviewReport() async {
    final sourceCharacters = await _dataSource.getSourceCharacters();
    final animeSeriesByMalId = await _dataSource.getAnimeSeriesByMalId();
    final enrichments = await _dataSource.getEnrichments();
    final allowedTagIds = await _dataSource.getAllowedTagIds();

    return _previewService.buildPreviewReport(
      sourceCharacters: sourceCharacters,
      enrichments: enrichments,
      allowedTagIds: allowedTagIds,
      animeSeriesByMalId: animeSeriesByMalId,
    );
  }

  Future<List<CharacterModel>> generatePreviewModels() async {
    final report = await generatePreviewReport();
    if (report.hasBlockingIssues) {
      throw StateError(report.issues.first.message);
    }

    return report.previewModels;
  }

  Future<String> generatePreviewJsonString() async {
    final sourceCharacters = await _dataSource.getSourceCharacters();
    final animeSeriesByMalId = await _dataSource.getAnimeSeriesByMalId();
    final enrichments = await _dataSource.getEnrichments();
    final allowedTagIds = await _dataSource.getAllowedTagIds();

    return _previewService.generatePreviewJsonString(
      sourceCharacters: sourceCharacters,
      enrichments: enrichments,
      allowedTagIds: allowedTagIds,
      animeSeriesByMalId: animeSeriesByMalId,
    );
  }

  Future<String> generateReviewQueueJsonString() async {
    final sourceCharacters = await _dataSource.getSourceCharacters();
    final animeSeriesByMalId = await _dataSource.getAnimeSeriesByMalId();
    final enrichments = await _dataSource.getEnrichments();
    final allowedTagIds = await _dataSource.getAllowedTagIds();

    return _previewService.generateReviewQueueJsonString(
      sourceCharacters: sourceCharacters,
      enrichments: enrichments,
      allowedTagIds: allowedTagIds,
      animeSeriesByMalId: animeSeriesByMalId,
    );
  }
}
