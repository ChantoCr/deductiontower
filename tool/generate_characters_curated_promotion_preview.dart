import 'dart:io';

import 'package:anime_deduction_tower/core/constants/asset_paths.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/services/character_import_promotion_service.dart';

import 'import_tool_io.dart';

Future<void> main() async {
  const service = CharacterImportPromotionService();
  final curatedCharacters = await readCuratedCharacters();
  final importedCharacters = await readImportedPreviewCharacters();
  final approvalEntries = await readApprovalEntries();
  final allowedTagIds = await readAllowedTagIds();

  final promotedJson = service.generatePromotedJsonString(
    curatedCharacters: curatedCharacters,
    importedCharacters: importedCharacters,
    approvalEntries: approvalEntries,
    allowedTagIds: allowedTagIds,
  );

  await File(AssetPaths.importCharactersCuratedPromotionPreviewData).writeAsString(
    '$promotedJson\n',
  );

  stdout.writeln(
    'Generated ${AssetPaths.importCharactersCuratedPromotionPreviewData} from curated and imported preview character data.',
  );
}
