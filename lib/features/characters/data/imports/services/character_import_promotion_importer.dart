import 'package:anime_deduction_tower/features/characters/data/imports/datasources/local_character_import_promotion_datasource.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/character_import_promotion_report.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/services/character_import_promotion_service.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';

class CharacterImportPromotionImporter {
  CharacterImportPromotionImporter({
    LocalCharacterImportPromotionDataSource? dataSource,
    CharacterImportPromotionService? promotionService,
  }) : _dataSource = dataSource ?? LocalCharacterImportPromotionDataSource(),
       _promotionService = promotionService ?? const CharacterImportPromotionService();

  final LocalCharacterImportPromotionDataSource _dataSource;
  final CharacterImportPromotionService _promotionService;

  Future<CharacterImportPromotionReport> generatePromotionReport() async {
    final curatedCharacters = await _dataSource.getCuratedCharacters();
    final importedCharacters = await _dataSource.getImportedPreviewCharacters();
    final approvalEntries = await _dataSource.getApprovalEntries();
    final allowedTagIds = await _dataSource.getAllowedTagIds();

    return _promotionService.buildPromotionReport(
      curatedCharacters: curatedCharacters,
      importedCharacters: importedCharacters,
      approvalEntries: approvalEntries,
      allowedTagIds: allowedTagIds,
    );
  }

  Future<List<CharacterModel>> generatePromotedCharacters() async {
    final report = await generatePromotionReport();
    if (report.hasBlockingIssues) {
      throw StateError(report.issues.first.message);
    }

    return report.promotedCharacters;
  }

  Future<String> generatePromotedJsonString() async {
    final curatedCharacters = await _dataSource.getCuratedCharacters();
    final importedCharacters = await _dataSource.getImportedPreviewCharacters();
    final approvalEntries = await _dataSource.getApprovalEntries();
    final allowedTagIds = await _dataSource.getAllowedTagIds();

    return _promotionService.generatePromotedJsonString(
      curatedCharacters: curatedCharacters,
      importedCharacters: importedCharacters,
      approvalEntries: approvalEntries,
      allowedTagIds: allowedTagIds,
    );
  }
}
