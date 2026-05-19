import 'package:anime_deduction_tower/features/characters/data/imports/models/character_import_approval_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CharacterImportApprovalEntry', () {
    test('parses approval metadata and reports approved status', () {
      final entry = CharacterImportApprovalEntry.fromJson({
        'malId': 13,
        'transformedId': 'sasuke_uchiha',
        'approvalStatus': 'approved',
        'notes': 'Approved for prototype use.',
      });

      expect(entry.malId, 13);
      expect(entry.transformedId, 'sasuke_uchiha');
      expect(entry.isApproved, isTrue);
      expect(entry.notes, 'Approved for prototype use.');
    });

    test('defaults missing status to pending', () {
      final entry = CharacterImportApprovalEntry.fromJson({
        'transformedId': 'levi_ackerman',
      });

      expect(entry.approvalStatus, 'pending');
      expect(entry.isApproved, isFalse);
    });
  });
}
