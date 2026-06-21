import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_event.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnlinePublicActionTimelineCard extends ConsumerWidget {
  const OnlinePublicActionTimelineCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(onlinePublicEventsProvider);

    return eventsAsync.when(
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Canonical public event timeline',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Watching persisted public event docs for resolved online actions.',
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
      data: (events) {
        final visibleEvents = events.take(5).toList(growable: false);
        final appliedCount = events.where((event) => event.isApplied).length;
        final rejectedCount = events.where((event) => event.isRejected).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Canonical public event timeline',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'These entries are persisted as explicit public event contracts during official queued-action resolution.',
              style: AppTextStyles.subtitle.copyWith(height: 1.4),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
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
            if (visibleEvents.isEmpty)
              Text(
                'No canonical public event docs are available yet.',
                style: AppTextStyles.subtitle.copyWith(height: 1.4),
              )
            else
              ...visibleEvents.map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _eventAccent(event).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: _eventAccent(event).withValues(alpha: 0.16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                event.shortLabel,
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            AppBadge(
                              label: _statusLabel(event.status),
                              accent: _eventAccent(event),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          event.actionSummary,
                          style: AppTextStyles.body.copyWith(height: 1.4),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.resultSummary,
                          style: AppTextStyles.subtitle.copyWith(height: 1.4),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            AppBadge(
                              icon: Icons.person_outline,
                              label: event.participantName,
                              accent: AppColors.primary,
                            ),
                            AppBadge(
                              icon: Icons.access_time_rounded,
                              label: _formatTimestamp(event.publishedAt),
                              accent: AppColors.secondary,
                            ),
                            AppBadge(
                              icon: Icons.history_toggle_off_rounded,
                              label: 'Version ${event.resultingMatchVersion}',
                              accent: AppColors.accent,
                            ),
                            if (event.submittedValueLabel != null)
                              AppBadge(
                                icon: Icons.label_outline,
                                label: event.submittedValueLabel!,
                                accent: AppColors.accent,
                              ),
                            if (event.resolutionSource != null)
                              AppBadge(
                                icon: Icons.verified_user_outlined,
                                label: event.resolutionSource!.label,
                                accent: AppColors.success,
                              ),
                          ],
                        ),
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

  Color _eventAccent(RemoteMatchPublicEvent event) {
    switch (event.status) {
      case OnlinePlayerActionStatus.pending:
        return AppColors.accent;
      case OnlinePlayerActionStatus.applied:
        return AppColors.success;
      case OnlinePlayerActionStatus.rejected:
        return AppColors.error;
    }
  }

  String _statusLabel(OnlinePlayerActionStatus status) {
    switch (status) {
      case OnlinePlayerActionStatus.pending:
        return 'PENDING';
      case OnlinePlayerActionStatus.applied:
        return 'APPLIED';
      case OnlinePlayerActionStatus.rejected:
        return 'REJECTED';
    }
  }

  String _formatTimestamp(DateTime value) {
    final utcValue = value.toUtc();
    final hour = utcValue.hour.toString().padLeft(2, '0');
    final minute = utcValue.minute.toString().padLeft(2, '0');
    final second = utcValue.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second UTC';
  }
}
