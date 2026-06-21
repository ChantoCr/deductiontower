import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_resolution.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/repositories/online_room_repository.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/online_action_resolution_policy.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_action_resolver.dart';

class OnlineActionResolutionController {
  OnlineActionResolutionController({
    required OnlineRoomRepository repository,
    required RemoteMatchActionResolver actionResolver,
    required OnlineActionResolutionPolicy resolutionPolicy,
    required OnlineActionResolutionAuthority resolutionAuthority,
    required Future<List<TraitCategory>> Function() loadValidCategories,
    required Future<List<Character>> Function() loadCharacters,
  })  : _repository = repository,
        _actionResolver = actionResolver,
        _resolutionPolicy = resolutionPolicy,
        _resolutionAuthority = resolutionAuthority,
        _loadValidCategories = loadValidCategories,
        _loadCharacters = loadCharacters;

  final OnlineRoomRepository _repository;
  final RemoteMatchActionResolver _actionResolver;
  final OnlineActionResolutionPolicy _resolutionPolicy;
  final OnlineActionResolutionAuthority _resolutionAuthority;
  final Future<List<TraitCategory>> Function() _loadValidCategories;
  final Future<List<Character>> Function() _loadCharacters;

  Future<RemoteMatchActionResolution> resolveAction({
    required OnlineRoomSession session,
    required String roomCode,
    required OnlinePlayerAction action,
  }) async {
    _ensureResolutionAuthority(session);
    final resolverUserId = _requireResolverUserId(session);

    return _resolvePersistedAction(
      roomCode: roomCode,
      action: action,
      resolvedByParticipantId: session.localParticipantId,
      resolvedByUserId: resolverUserId,
      resolutionSource: _resolutionAuthority,
    );
  }

  Future<RemoteMatchActionResolution> resolveNextPendingAction({
    required OnlineRoomSession session,
    required String roomCode,
    required List<OnlinePlayerAction> actions,
  }) {
    return resolveAction(
      session: session,
      roomCode: roomCode,
      action: _oldestPendingAction(actions),
    );
  }

  Future<RemoteMatchActionResolution> _resolvePersistedAction({
    required String roomCode,
    required OnlinePlayerAction action,
    required String resolvedByParticipantId,
    required String resolvedByUserId,
    required OnlineActionResolutionAuthority resolutionSource,
  }) async {
    if (action.status != OnlinePlayerActionStatus.pending) {
      throw StateError('Only pending queued actions can be resolved.');
    }

    final handoff = await _repository.readMatchHandoff(
      roomCode: roomCode,
      participantId: action.submittedByParticipantId,
    );
    if (handoff == null || !handoff.isComplete) {
      throw StateError(
        'Remote action resolution requires persisted bootstrap, public, and participant private docs.',
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
      resolvedByParticipantId: resolvedByParticipantId,
      resolvedByUserId: resolvedByUserId,
      resolutionSource: resolutionSource,
    );

    await _repository.persistActionResolution(
      roomCode: roomCode,
      resolution: resolution,
    );
    return resolution;
  }

  OnlinePlayerAction _oldestPendingAction(List<OnlinePlayerAction> actions) {
    final pendingAction = _firstPendingActionOrNull(actions);
    if (pendingAction == null) {
      throw StateError(
        'No pending online player actions are available to resolve.',
      );
    }

    return pendingAction;
  }

  OnlinePlayerAction? _firstPendingActionOrNull(
    List<OnlinePlayerAction> actions,
  ) {
    final pendingActions = actions
        .where((action) => action.status == OnlinePlayerActionStatus.pending)
        .toList()
      ..sort((left, right) => left.createdAt.compareTo(right.createdAt));

    if (pendingActions.isEmpty) {
      return null;
    }

    return pendingActions.first;
  }

  void _ensureResolutionAuthority(OnlineRoomSession session) {
    final canResolve = _resolutionPolicy.canLocalClientResolveQueuedActions(
      authority: _resolutionAuthority,
      session: session,
    );
    if (!canResolve) {
      throw StateError(
        'This client is not the current queued-action resolver. ${_resolutionAuthority.description}',
      );
    }
  }

  String _requireResolverUserId(OnlineRoomSession session) {
    final userId = session.localParticipant.userId?.trim();
    if (userId == null || userId.isEmpty) {
      throw StateError(
        'The current queued-action resolver is missing a local user id.',
      );
    }

    return userId;
  }
}
