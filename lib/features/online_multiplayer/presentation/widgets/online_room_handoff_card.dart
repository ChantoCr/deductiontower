import 'package:anime_deduction_tower/features/online_multiplayer/data/config/online_backend_target.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_screen_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/widgets/online_bootstrap_preview_card.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_badge.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnlineRoomHandoffCard extends ConsumerWidget {
  const OnlineRoomHandoffCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backendTarget = ref.watch(onlineBackendTargetProvider);
    if (backendTarget != OnlineBackendTarget.firebaseBackend) {
      return const OnlineBootstrapPreviewCard();
    }

    final session = ref.watch(
      onlineLobbyControllerProvider.select((state) => state.activeSession),
    );

    if (session == null) {
      return const AppCard(
        glowColor: AppColors.success,
        child: _FirebaseHandoffEmpty(),
      );
    }

    if (session.phase != OnlineRoomPhase.readyToSync || !session.isEveryoneReady) {
      return AppCard(
        glowColor: AppColors.accent,
        child: _FirebaseHandoffWaitingForLobby(session: session),
      );
    }

    final handoffAsync = ref.watch(remoteMatchHandoffProvider);
    return AppCard(
      glowColor: AppColors.success,
      child: handoffAsync.when(
        loading: () => _FirebaseHandoffLoading(session: session),
        error: (error, stackTrace) => _FirebaseHandoffError(error: error),
        data: (snapshot) {
          if (snapshot == null) {
            return _FirebaseHandoffPending(session: session);
          }

          if (!snapshot.isComplete) {
            return _FirebaseHandoffPartial(
              session: session,
              snapshot: snapshot,
            );
          }

          return _FirebaseHandoffReady(
            session: session,
            snapshot: snapshot,
          );
        },
      ),
    );
  }
}

class _FirebaseHandoffEmpty extends StatelessWidget {
  const _FirebaseHandoffEmpty();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Firebase room-to-match handoff', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Create or join a Firebase room first. Once the live lobby exists, this panel will watch the persisted bootstrap, public match, and local private match documents.',
          style: AppTextStyles.subtitle.copyWith(height: 1.45),
        ),
      ],
    );
  }
}

class _FirebaseHandoffWaitingForLobby extends StatelessWidget {
  const _FirebaseHandoffWaitingForLobby({required this.session});

  final OnlineRoomSession session;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Firebase room-to-match handoff', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'The handoff watcher is ready, but this room still needs both participants connected and marked ready before bootstrap documents should exist.',
          style: AppTextStyles.subtitle.copyWith(height: 1.45),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            AppBadge(
              icon: Icons.key_outlined,
              label: 'Room: ${session.roomCode}',
              accent: AppColors.primary,
            ),
            AppBadge(
              icon: Icons.people_alt_outlined,
              label: 'Participants: ${session.participantCount}/2',
              accent: AppColors.secondary,
            ),
            AppBadge(
              icon: Icons.schedule_outlined,
              label: _phaseLabel(session.phase),
              accent: AppColors.accent,
            ),
          ],
        ),
      ],
    );
  }
}

class _FirebaseHandoffLoading extends StatelessWidget {
  const _FirebaseHandoffLoading({required this.session});

  final OnlineRoomSession session;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Firebase room-to-match handoff', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Watching persisted room-to-match documents for ${session.roomCode}. This covers the bootstrap payload, public match state, and the local player\'s private document.',
          style: AppTextStyles.subtitle.copyWith(height: 1.45),
        ),
        const SizedBox(height: AppSpacing.md),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class _FirebaseHandoffError extends StatelessWidget {
  const _FirebaseHandoffError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Firebase room-to-match handoff', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'The lobby reached live handoff watching, but the persisted documents could not be read safely.',
          style: AppTextStyles.subtitle.copyWith(height: 1.45),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.16)),
          ),
          child: Text(
            '$error',
            style: AppTextStyles.body.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}

class _FirebaseHandoffPending extends StatelessWidget {
  const _FirebaseHandoffPending({required this.session});

  final OnlineRoomSession session;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Firebase room-to-match handoff', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Both players are ready, so this room is now waiting for persisted bootstrap documents to appear. Keep this screen open to verify the room can reconnect without rebuilding the match in the UI.',
          style: AppTextStyles.subtitle.copyWith(height: 1.45),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            const AppBadge(
              icon: Icons.sync_outlined,
              label: 'Bootstrap pending',
              accent: AppColors.accent,
            ),
            AppBadge(
              icon: Icons.key_outlined,
              label: 'Room: ${session.roomCode}',
              accent: AppColors.primary,
            ),
            AppBadge(
              icon: Icons.person_outline,
              label: 'Local: ${session.localParticipant.displayName}',
              accent: AppColors.secondary,
            ),
          ],
        ),
      ],
    );
  }
}

class _FirebaseHandoffPartial extends StatelessWidget {
  const _FirebaseHandoffPartial({
    required this.session,
    required this.snapshot,
  });

  final OnlineRoomSession session;
  final RemoteMatchHandoffSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Firebase room-to-match handoff', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Some persisted handoff documents are already visible. This is useful for reconnect verification because the screen can distinguish public/bootstrap progress from the local player\'s private document readiness.',
          style: AppTextStyles.subtitle.copyWith(height: 1.45),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            const AppBadge(
              icon: Icons.hourglass_top_rounded,
              label: 'Reconnect not ready yet',
              accent: AppColors.accent,
            ),
            _documentBadge(
              label: 'Bootstrap doc',
              isReady: snapshot.hasBootstrapPayload,
            ),
            _documentBadge(
              label: 'Public match doc',
              isReady: snapshot.hasPublicState,
            ),
            _documentBadge(
              label: 'Local private doc',
              isReady: snapshot.hasPrivateState,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _HandoffSection(
          title: 'Observed handoff context',
          child: Column(
            children: [
              _InfoRow(label: 'Room code', value: session.roomCode),
              _InfoRow(
                label: 'Local participant',
                value: session.localParticipant.displayName,
              ),
              _InfoRow(
                label: 'Detected match id',
                value: snapshot.matchId ?? 'Waiting for persisted id',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FirebaseHandoffReady extends StatelessWidget {
  const _FirebaseHandoffReady({
    required this.session,
    required this.snapshot,
  });

  final OnlineRoomSession session;
  final RemoteMatchHandoffSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final payload = snapshot.bootstrapPayload!;
    final publicState = snapshot.publicState!;
    final privateState = snapshot.privateState!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Firebase room-to-match handoff', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Reconnect-ready handoff detected. The screen is now reading persisted bootstrap, public match, and local private state from Firestore instead of rebuilding that startup bundle locally.',
          style: AppTextStyles.subtitle.copyWith(height: 1.45),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            const AppBadge(
              icon: Icons.cloud_done_outlined,
              label: 'Reconnect ready',
              accent: AppColors.success,
            ),
            AppBadge(
              icon: Icons.play_arrow_rounded,
              label:
                  'Turn: ${publicState.currentTurnPlayerState?.displayName ?? publicState.currentTurnParticipantId}',
              accent: AppColors.primary,
            ),
            AppBadge(
              icon: Icons.history_toggle_off_rounded,
              label: 'Version: ${publicState.matchVersion}',
              accent: AppColors.secondary,
            ),
            const AppBadge(
              icon: Icons.lock_outline_rounded,
              label: 'Private doc scoped locally',
              accent: AppColors.accent,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _HandoffSection(
          title: 'Persisted bootstrap payload',
          child: Column(
            children: [
              _InfoRow(label: 'Room code', value: payload.roomCode),
              _InfoRow(label: 'Match id', value: payload.matchId),
              _InfoRow(
                label: 'Players',
                value: '${payload.hostPlayerName} vs ${payload.guestPlayerName}',
              ),
              _InfoRow(
                label: 'Starting turn',
                value: publicState.currentTurnPlayerState?.displayName ??
                    payload.startingParticipantId,
              ),
              _InfoRow(
                label: 'Shared pool size',
                value: '${payload.sharedCharacterPoolIds.length} characters',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _HandoffSection(
          title: 'Persisted public match state',
          child: Column(
            children: [
              _InfoRow(label: 'Status', value: publicState.status.name),
              _InfoRow(label: 'Turn number', value: '${publicState.turnNumber}'),
              _InfoRow(
                label: 'Current participant',
                value: publicState.currentTurnPlayerState?.displayName ??
                    publicState.currentTurnParticipantId,
              ),
              _InfoRow(
                label: 'Last resolved action',
                value: publicState.lastResolvedActionId ?? 'None yet',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _HandoffSection(
          title: 'Local private reconnect scope',
          child: Column(
            children: [
              _InfoRow(
                label: 'Local player',
                value: session.localParticipant.displayName,
              ),
              _InfoRow(
                label: 'Secret assigned',
                value: privateState.hasSecretAssigned ? 'Yes' : 'No',
              ),
              _InfoRow(
                label: 'Secret locked',
                value: privateState.secretTraitLocked ? 'Yes' : 'No',
              ),
              _InfoRow(
                label: 'Has viewed secret',
                value: privateState.hasViewedSecret ? 'Yes' : 'No',
              ),
              _InfoRow(
                label: 'Hints used',
                value: '${privateState.hintsUsed}',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.16)),
          ),
          child: Text(
            'This lobby can now hand off or reconnect into a future remote match screen using persisted documents instead of regenerating startup state inside presentation code.',
            style: AppTextStyles.body.copyWith(height: 1.4),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const _RemoteMatchScreenStateSection(),
      ],
    );
  }
}

class _RemoteMatchScreenStateSection extends ConsumerWidget {
  const _RemoteMatchScreenStateSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenStateAsync = ref.watch(remoteMatchScreenStateProvider);

    return _HandoffSection(
      title: 'Gameplay-ready remote screen state',
      child: screenStateAsync.when(
        loading: () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hydrating a gameplay-ready remote screen state from persisted bootstrap, public, and private documents.',
              style: AppTextStyles.subtitle.copyWith(height: 1.4),
            ),
            const SizedBox(height: AppSpacing.md),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
        error: (error, stackTrace) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.16)),
          ),
          child: Text(
            '$error',
            style: AppTextStyles.body.copyWith(height: 1.4),
          ),
        ),
        data: (screenState) {
          if (screenState == null) {
            return Text(
              'No gameplay-ready remote state is available yet.',
              style: AppTextStyles.subtitle.copyWith(height: 1.4),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(label: 'Room code', value: screenState.roomCode),
              _InfoRow(label: 'Match id', value: screenState.match.id),
              _InfoRow(
                label: 'Local player',
                value: screenState.localPlayer.name,
              ),
              _InfoRow(
                label: 'Remote player',
                value: screenState.remotePlayer.name,
              ),
              _InfoRow(
                label: 'Local secret tag',
                value: screenState.localSecretTrait.label,
              ),
              _InfoRow(
                label: 'Current turn',
                value: screenState.match.currentPlayer.name,
              ),
              _InfoRow(
                label: 'Shared pool',
                value: '${screenState.sharedCharacterPoolSize} characters',
              ),
              _InfoRow(
                label: 'Match version',
                value: '${screenState.matchVersion}',
              ),
              _InfoRow(
                label: 'Local turn ready',
                value: screenState.isLocalPlayersTurn ? 'Yes' : 'Waiting',
              ),
              const SizedBox(height: AppSpacing.md),
              _RemoteActionQueueControls(screenState: screenState),
              const SizedBox(height: AppSpacing.md),
              const _RemoteActionQueueFeed(),
            ],
          );
        },
      ),
    );
  }
}

class _RemoteActionQueueControls extends ConsumerWidget {
  const _RemoteActionQueueControls({required this.screenState});

  final RemoteMatchScreenState screenState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onlineActionQueueControllerProvider);
    final firstCharacterId = screenState.characterPool.isEmpty
        ? null
        : screenState.characterPool.first.id;

    Future<void> queueAction(
      Future<OnlinePlayerAction> Function() submit,
      String successLabel,
    ) async {
      try {
        final action = await submit();
        if (!context.mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$successLabel queued as ${action.actionId}.',
            ),
          ),
        );
      } catch (error) {
        if (!context.mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$error')),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Queue online player actions',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'These controls only submit explicit remote action contracts into the queue. They do not resolve the official match locally.',
          style: AppTextStyles.subtitle.copyWith(height: 1.4),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            AppBadge(
              icon: Icons.play_circle_outline,
              label: screenState.canQueueLocalAction
                  ? 'Local turn can queue'
                  : 'Waiting for local turn',
              accent: screenState.canQueueLocalAction
                  ? AppColors.success
                  : AppColors.accent,
            ),
            if (screenState.lastResolvedActionId != null)
              AppBadge(
                icon: Icons.history_toggle_off_rounded,
                label: 'Last resolved: ${screenState.lastResolvedActionId}',
                accent: AppColors.secondary,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Queue Hint Request',
          icon: Icons.tips_and_updates_outlined,
          onPressed: screenState.canQueueLocalAction &&
                  screenState.localPlayer.hintsRemaining > 0
              ? () => queueAction(
                    () => controller.queueHintRequest(screenState),
                    'Hint request',
                  )
              : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: 'Queue First Pool Probe',
          icon: Icons.person_search_outlined,
          isPrimary: false,
          onPressed: screenState.canQueueLocalAction && firstCharacterId != null
              ? () => queueAction(
                    () => controller.queueCharacterGuess(
                      screenState: screenState,
                      characterId: firstCharacterId,
                    ),
                    'Character probe',
                  )
              : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: 'Queue Surrender',
          icon: Icons.flag_outlined,
          isPrimary: false,
          onPressed: screenState.canQueueLocalAction
              ? () => queueAction(
                    () => controller.queueSurrender(screenState),
                    'Surrender action',
                  )
              : null,
        ),
      ],
    );
  }
}

class _RemoteActionQueueFeed extends ConsumerWidget {
  const _RemoteActionQueueFeed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionsAsync = ref.watch(onlinePlayerActionsProvider);

    return actionsAsync.when(
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Queued remote actions',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Watching the explicit queued-action collection for this room.',
            style: AppTextStyles.subtitle.copyWith(height: 1.4),
          ),
          const SizedBox(height: AppSpacing.md),
          const Center(child: CircularProgressIndicator()),
        ],
      ),
      error: (error, stackTrace) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.16)),
        ),
        child: Text(
          '$error',
          style: AppTextStyles.body.copyWith(height: 1.4),
        ),
      ),
      data: (actions) {
        final visibleActions = actions.take(5).toList(growable: false);
        final pendingCount = actions.where((action) => action.status.name == 'pending').length;
        final appliedCount = actions.where((action) => action.status.name == 'applied').length;
        final rejectedCount = actions.where((action) => action.status.name == 'rejected').length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Queued remote actions',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'This feed reads the queued online player actions through the datasource/repository boundary. Official resolution still belongs to later match-sync logic.',
              style: AppTextStyles.subtitle.copyWith(height: 1.4),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                AppBadge(
                  icon: Icons.schedule_outlined,
                  label: 'Pending: $pendingCount',
                  accent: AppColors.accent,
                ),
                AppBadge(
                  icon: Icons.check_circle_outline,
                  label: 'Applied: $appliedCount',
                  accent: AppColors.success,
                ),
                AppBadge(
                  icon: Icons.cancel_outlined,
                  label: 'Rejected: $rejectedCount',
                  accent: AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (visibleActions.isEmpty)
              Text(
                'No remote player actions have been queued yet.',
                style: AppTextStyles.subtitle.copyWith(height: 1.4),
              )
            else
              ...visibleActions.map(
                (action) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _actionAccent(action).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: _actionAccent(action).withValues(alpha: 0.16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _actionTitle(action),
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            AppBadge(
                              label: action.status.name.toUpperCase(),
                              accent: _actionAccent(action),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Participant: ${action.submittedByParticipantId} · Expected version: ${action.expectedMatchVersion}',
                          style: AppTextStyles.subtitle.copyWith(height: 1.4),
                        ),
                        if (action.submittedValue.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Value: ${action.submittedValue}',
                            style: AppTextStyles.subtitle.copyWith(height: 1.4),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _HandoffSection extends StatelessWidget {
  const _HandoffSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 132,
            child: Text(
              label,
              style: AppTextStyles.label.copyWith(color: AppColors.secondary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body.copyWith(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

AppBadge _documentBadge({required String label, required bool isReady}) {
  return AppBadge(
    icon: isReady ? Icons.check_circle_outline : Icons.schedule_outlined,
    label: '$label: ${isReady ? 'ready' : 'waiting'}',
    accent: isReady ? AppColors.success : AppColors.accent,
  );
}

Color _actionAccent(OnlinePlayerAction action) {
  switch (action.status.name) {
    case 'applied':
      return AppColors.success;
    case 'rejected':
      return AppColors.error;
    case 'pending':
    default:
      return AppColors.accent;
  }
}

String _actionTitle(OnlinePlayerAction action) {
  switch (action.actionType.name) {
    case 'guessCharacter':
      return 'Character guess queued';
    case 'guessTrait':
      return 'Trait guess queued';
    case 'requestHint':
      return 'Hint request queued';
    case 'surrender':
      return 'Surrender queued';
    case 'pass':
      return 'Pass queued';
    default:
      return 'Queued action';
  }
}

String _phaseLabel(OnlineRoomPhase phase) {
  switch (phase) {
    case OnlineRoomPhase.waitingForOpponent:
      return 'Waiting for opponent';
    case OnlineRoomPhase.waitingForReady:
      return 'Waiting for ready';
    case OnlineRoomPhase.readyToSync:
      return 'Ready to sync';
  }
}
