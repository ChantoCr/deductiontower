class CharacterImportValidationIssue {
  const CharacterImportValidationIssue({
    required this.code,
    required this.message,
    this.isBlocking = true,
    this.sourceMalId,
    this.characterName,
    this.characterId,
    this.tagId,
  });

  final String code;
  final String message;
  final bool isBlocking;
  final int? sourceMalId;
  final String? characterName;
  final String? characterId;
  final String? tagId;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'isBlocking': isBlocking,
      'sourceMalId': sourceMalId,
      'characterName': characterName,
      'characterId': characterId,
      'tagId': tagId,
    };
  }
}
