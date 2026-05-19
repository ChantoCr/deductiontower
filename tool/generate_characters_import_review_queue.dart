import 'dart:io';

import 'package:anime_deduction_tower/core/constants/asset_paths.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/services/external_character_import_preview_service.dart';

import 'import_tool_io.dart';

Future<void> main() async {
  const service = ExternalCharacterImportPreviewService();
  final sourceCharacters = await readSourceCharacters();
  final animeSeriesByMalId = await readAnimeSeriesByMalId();
  final enrichments = await readEnrichments();
  final allowedTagIds = await readAllowedTagIds();

  final reviewQueueJson = service.generateReviewQueueJsonString(
    sourceCharacters: sourceCharacters,
    enrichments: enrichments,
    allowedTagIds: allowedTagIds,
    animeSeriesByMalId: animeSeriesByMalId,
  );

  await File(AssetPaths.importCharactersReviewQueueData).writeAsString('$reviewQueueJson\n');
  stdout.writeln(
    'Generated ${AssetPaths.importCharactersReviewQueueData} from prototype MAL/Jikan import review data.',
  );
}
