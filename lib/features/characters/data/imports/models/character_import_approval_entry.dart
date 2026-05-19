class CharacterImportApprovalEntry {
  const CharacterImportApprovalEntry({
    required this.transformedId,
    required this.approvalStatus,
    this.malId,
    this.notes,
  });

  factory CharacterImportApprovalEntry.fromJson(Map<String, dynamic> json) {
    return CharacterImportApprovalEntry(
      transformedId: json['transformedId'] as String,
      approvalStatus: json['approvalStatus'] as String? ?? 'pending',
      malId: json['malId'] as int?,
      notes: json['notes'] as String?,
    );
  }

  final int? malId;
  final String transformedId;
  final String approvalStatus;
  final String? notes;

  bool get isApproved => approvalStatus == 'approved';

  Map<String, dynamic> toJson() {
    return {
      'malId': malId,
      'transformedId': transformedId,
      'approvalStatus': approvalStatus,
      'notes': notes,
    };
  }
}
