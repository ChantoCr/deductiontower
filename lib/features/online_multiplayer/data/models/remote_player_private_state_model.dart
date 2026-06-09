import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';

class RemotePlayerPrivateStateModel {
  const RemotePlayerPrivateStateModel({
    required this.participantId,
    required this.userId,
    required this.secretTraitId,
    required this.secretTraitLocked,
    required this.hasViewedSecret,
    required this.hintsUsed,
    required this.selectedAt,
    required this.updatedAt,
    this.lastPrivateHintText,
  });

  final String participantId;
  final String userId;
  final String secretTraitId;
  final bool secretTraitLocked;
  final bool hasViewedSecret;
  final int hintsUsed;
  final String? lastPrivateHintText;
  final DateTime selectedAt;
  final DateTime updatedAt;

  factory RemotePlayerPrivateStateModel.fromJson(Map<String, dynamic> json) {
    return RemotePlayerPrivateStateModel(
      participantId: json['participantId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      secretTraitId: json['secretTraitId'] as String? ?? '',
      secretTraitLocked: json['secretTraitLocked'] as bool? ?? false,
      hasViewedSecret: json['hasViewedSecret'] as bool? ?? false,
      hintsUsed: json['hintsUsed'] as int? ?? 0,
      lastPrivateHintText: json['lastPrivateHintText'] as String?,
      selectedAt: DateTime.tryParse(json['selectedAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  factory RemotePlayerPrivateStateModel.fromEntity(
    RemotePlayerPrivateState entity,
  ) {
    return RemotePlayerPrivateStateModel(
      participantId: entity.participantId,
      userId: entity.userId,
      secretTraitId: entity.secretTraitId,
      secretTraitLocked: entity.secretTraitLocked,
      hasViewedSecret: entity.hasViewedSecret,
      hintsUsed: entity.hintsUsed,
      lastPrivateHintText: entity.lastPrivateHintText,
      selectedAt: entity.selectedAt,
      updatedAt: entity.updatedAt,
    );
  }

  RemotePlayerPrivateState toEntity() {
    return RemotePlayerPrivateState(
      participantId: participantId,
      userId: userId,
      secretTraitId: secretTraitId,
      secretTraitLocked: secretTraitLocked,
      hasViewedSecret: hasViewedSecret,
      hintsUsed: hintsUsed,
      lastPrivateHintText: lastPrivateHintText,
      selectedAt: selectedAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantId': participantId,
      'userId': userId,
      'secretTraitId': secretTraitId,
      'secretTraitLocked': secretTraitLocked,
      'hasViewedSecret': hasViewedSecret,
      'hintsUsed': hintsUsed,
      'lastPrivateHintText': lastPrivateHintText,
      'selectedAt': selectedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
