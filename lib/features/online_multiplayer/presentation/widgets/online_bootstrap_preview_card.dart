import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_result.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_badge.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnlineBootstrapPreviewCard extends ConsumerWidget {
  const OnlineBootstrapPreviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewAsync = ref.watch(remoteMatchBootstrapPreviewProvider);
    final hintsPerPlayer = ref.watch(onlinePreviewHintsPerPlayerProvider);

    return AppCard(
      glowColor: AppColors.success,
      child: previewAsync.when(
        loading: () => const _BootstrapPreviewLoading(),
        error: (error, stackTrace) => _BootstrapPreviewError(error: error),
        data: (preview) {
          if (preview == null) {
            return _BootstrapPreviewEmpty(hintsPerPlayer: hintsPerPlayer);
          }

          return _BootstrapPreviewData(
            preview: preview,
            hintsPerPlayer: hintsPerPlayer,
          );
        },
      ),
    );
  }
}

class _BootstrapPreviewLoading extends StatelessWidget {
  const _BootstrapPreviewLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Remote bootstrap preview', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Preparing a Firebase-shaped room-to-match preview from the current mock lobby state.',
          style: AppTextStyles.subtitle.copyWith(height: 1.4),
        ),
        const SizedBox(height: AppSpacing.md),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class _BootstrapPreviewError extends StatelessWidget {
  const _BootstrapPreviewError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Remote bootstrap preview', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'The preview could not build a remote match bootstrap summary from the current room state.',
          style: AppTextStyles.subtitle.copyWith(height: 1.4),
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
            style: AppTextStyles.body.copyWith(
              color: AppColors.text,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _BootstrapPreviewEmpty extends StatelessWidget {
  const _BootstrapPreviewEmpty({required this.hintsPerPlayer});

  final int hintsPerPlayer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Remote bootstrap preview', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'This preview stays empty until the room reaches a ready-to-sync state. Simulate a remote guest, mark both sides ready, and the screen will assemble the next remote match payload.',
          style: AppTextStyles.subtitle.copyWith(height: 1.45),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            const AppBadge(
              icon: Icons.visibility_off_outlined,
              label: 'Private traits stay masked',
              accent: AppColors.secondary,
            ),
            AppBadge(
              icon: Icons.tips_and_updates_outlined,
              label: 'Preview assumes $hintsPerPlayer hints/player',
              accent: AppColors.accent,
            ),
          ],
        ),
      ],
    );
  }
}

class _BootstrapPreviewData extends StatelessWidget {
  const _BootstrapPreviewData({
    required this.preview,
    required this.hintsPerPlayer,
  });

  final RemoteMatchBootstrapResult preview;
  final int hintsPerPlayer;

  @override
  Widget build(BuildContext context) {
    final payload = preview.payload;
    final publicState = preview.publicState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Remote bootstrap preview', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'This card previews the room-to-match payload that a future Firebase-backed online flow could generate once both players are ready.',
          style: AppTextStyles.subtitle.copyWith(height: 1.45),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            AppBadge(
              icon: Icons.play_arrow_rounded,
              label: 'Start: ${publicState.currentTurnPlayerState?.displayName ?? payload.startingParticipantId}',
              accent: AppColors.success,
            ),
            AppBadge(
              icon: Icons.grid_view_rounded,
              label: 'Pool: ${payload.sharedCharacterPoolIds.length}',
              accent: AppColors.primary,
            ),
            AppBadge(
              icon: Icons.tips_and_updates_outlined,
              label: 'Hints/player: $hintsPerPlayer',
              accent: AppColors.accent,
            ),
            const AppBadge(
              icon: Icons.lock_outline_rounded,
              label: 'Secrets masked in preview',
              accent: AppColors.secondary,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _PreviewSection(
          title: 'Bootstrap payload',
          child: Column(
            children: [
              _InfoRow(label: 'Room code', value: payload.roomCode),
              _InfoRow(label: 'Match id', value: payload.matchId),
              _InfoRow(
                label: 'Host / guest',
                value: '${payload.hostPlayerName} vs ${payload.guestPlayerName}',
              ),
              _InfoRow(
                label: 'Starting participant',
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
        _PreviewSection(
          title: 'Initial public match state',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(label: 'Status', value: publicState.status.name),
              _InfoRow(label: 'Turn number', value: '${publicState.turnNumber}'),
              _InfoRow(label: 'Match version', value: '${publicState.matchVersion}'),
              const SizedBox(height: AppSpacing.sm),
              ...publicState.playerStates.map(
                (playerState) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playerState.displayName,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Hints remaining: ${playerState.hintsRemaining} · Character guesses: ${playerState.characterGuessCount} · Trait guesses: ${playerState.traitGuessCount}',
                          style: AppTextStyles.subtitle.copyWith(height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _PreviewSection(
          title: 'Private player state documents',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Private state is intentionally masked here to mirror the future online secrecy boundary. The preview only confirms that a secret was assigned and locked for each participant.',
                style: AppTextStyles.subtitle.copyWith(height: 1.4),
              ),
              const SizedBox(height: AppSpacing.md),
              ...preview.privatePlayerStates.map(
                (privateState) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          privateState.participantId,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Secret assigned: ${privateState.hasSecretAssigned ? 'yes' : 'no'} · Locked: ${privateState.secretTraitLocked ? 'yes' : 'no'} · Viewed: ${privateState.hasViewedSecret ? 'yes' : 'no'} · Hints used: ${privateState.hintsUsed}',
                          style: AppTextStyles.subtitle.copyWith(height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({required this.title, required this.child});

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
