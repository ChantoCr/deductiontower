import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_resolution.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_action_resolver.dart';

abstract class RemoteMatchBackendAuthorityStore {
  Future<OnlinePlayerAction?> readOldestPendingAction(String roomCode);

  Future<RemoteMatchHandoffSnapshot?> readMatchHandoff({
    required String roomCode,
    required String participantId,
  });

  Future<void> persistActionResolution({
    required String roomCode,
    required RemoteMatchActionResolution resolution,
  });
}

class RemoteMatchBackendAuthorityService {
  RemoteMatchBackendAuthorityService({
    required Future<List<TraitCategory>> Function() loadValidCategories,
    required Future<List<Character>> Function() loadCharacters,
    RemoteMatchActionResolver? actionResolver,
  })  : _loadValidCategories = loadValidCategories,
        _loadCharacters = loadCharacters,
        _actionResolver = actionResolver ?? const RemoteMatchActionResolver();

  static const resolverParticipantId = 'backend_authority';
  static const resolverUserId = 'backend_authority_service';

  final Future<List<TraitCategory>> Function() _loadValidCategories;
  final Future<List<Character>> Function() _loadCharacters;
  final RemoteMatchActionResolver _actionResolver;

  Future<RemoteMatchActionResolution?> resolveOldestPendingAction({
    required String roomCode,
    required RemoteMatchBackendAuthorityStore store,
  }) async {
    final action = await store.readOldestPendingAction(roomCode);
    if (action == null) {
      return null;
    }

    if (action.status != OnlinePlayerActionStatus.pending) {
      throw StateError('Backend authority can only resolve pending actions.');
    }

    final handoff = await store.readMatchHandoff(
      roomCode: roomCode,
      participantId: action.submittedByParticipantId,
    );
    if (handoff == null || !handoff.isComplete) {
      throw StateError(
        'Backend authority resolution requires persisted bootstrap, public, and participant private docs.',
      );
    }

    final categories = await _loadValidCategories();
    final characters = await _loadCharacters();
    final resolution = _actionResolver.resolve(
      payload: handoff.bootstrapPayload!,
      publicState: handoff.publicState!,
      privateState: handoff.privateState!,
      action: action,
      categories: categories,
      characters: characters,
      resolvedByParticipantId: resolverParticipantId,
      resolvedByUserId: resolverUserId,
      resolutionSource: OnlineActionResolutionAuthority.backendService,
    );

    await store.persistActionResolution(
      roomCode: roomCode,
      resolution: resolution,
    );
    return resolution;
  }

  Future<int> drainPendingActions({
    required String roomCode,
    required RemoteMatchBackendAuthorityStore store,
    int maxActionsPerRun = 25,
  }) async {
    var resolvedCount = 0;

    while (resolvedCount < maxActionsPerRun) {
      final resolution = await resolveOldestPendingAction(
        roomCode: roomCode,
        store: store,
      );
      if (resolution == null) {
        return resolvedCount;
      }

      resolvedCount += 1;
    }

    return resolvedCount;
  }
}
