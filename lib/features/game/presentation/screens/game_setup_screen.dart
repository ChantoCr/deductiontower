import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/core/constants/game_constants.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/category_selection_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/game_setup_controller.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GameSetupScreen extends ConsumerStatefulWidget {
  const GameSetupScreen({super.key});

  @override
  ConsumerState<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends ConsumerState<GameSetupScreen> {
  late final TextEditingController _playerOneController;
  late final TextEditingController _playerTwoController;

  @override
  void initState() {
    super.initState();
    final setupState = ref.read(gameSetupControllerProvider);
    _playerOneController =
        TextEditingController(text: setupState.playerOneName);
    _playerTwoController =
        TextEditingController(text: setupState.playerTwoName);
  }

  @override
  void dispose() {
    _playerOneController.dispose();
    _playerTwoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(gameSetupControllerProvider);
    final controller = ref.read(gameSetupControllerProvider.notifier);

    return AppScaffold(
      title: 'Single Device Match',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useWidePlayersLayout = constraints.maxWidth >= 760;

          return ListView(
            children: [
              _SetupHeroCard(hints: setupState.hints),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Player identities',
                style: AppTextStyles.title.copyWith(fontSize: 22),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Give each side a clear name. The fields are separated for better readability during quick setup and pass-the-device play.',
                style: AppTextStyles.subtitle.copyWith(height: 1.45),
              ),
              const SizedBox(height: AppSpacing.md),
              if (useWidePlayersLayout)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _PlayerSetupCard(
                        title: 'Player One',
                        helper:
                            'Appears in turn flow, match status, and the result timeline.',
                        icon: Icons.looks_one_rounded,
                        accent: AppColors.primary,
                        controller: _playerOneController,
                        label: 'Player one name',
                        onChanged: controller.updatePlayerOneName,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _PlayerSetupCard(
                        title: 'Player Two',
                        helper:
                            'Names are trimmed automatically and never saved as blank.',
                        icon: Icons.looks_two_rounded,
                        accent: AppColors.secondary,
                        controller: _playerTwoController,
                        label: 'Player two name',
                        onChanged: controller.updatePlayerTwoName,
                      ),
                    ),
                  ],
                )
              else ...[
                _PlayerSetupCard(
                  title: 'Player One',
                  helper:
                      'Appears in turn flow, match status, and the result timeline.',
                  icon: Icons.looks_one_rounded,
                  accent: AppColors.primary,
                  controller: _playerOneController,
                  label: 'Player one name',
                  onChanged: controller.updatePlayerOneName,
                ),
                const SizedBox(height: AppSpacing.md),
                _PlayerSetupCard(
                  title: 'Player Two',
                  helper:
                      'Names are trimmed automatically and never saved as blank.',
                  icon: Icons.looks_two_rounded,
                  accent: AppColors.secondary,
                  controller: _playerTwoController,
                  label: 'Player two name',
                  onChanged: controller.updatePlayerTwoName,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              _HintsSetupCard(
                hints: setupState.hints,
                onChanged: controller.updateHints,
              ),
              const SizedBox(height: AppSpacing.md),
              _MatchPreviewCard(
                playerOneName: setupState.playerOneName,
                playerTwoName: setupState.playerTwoName,
                hints: setupState.hints,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Continue to Secret Tag Selection',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  controller.updatePlayerNames(
                    playerOneName: _playerOneController.text,
                    playerTwoName: _playerTwoController.text,
                  );
                  ref
                      .read(categorySelectionControllerProvider.notifier)
                      .reset();
                  context.go(AppRoutes.categorySelection);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SetupHeroCard extends StatelessWidget {
  const _SetupHeroCard({required this.hints});

  final int hints;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text('SETUP', style: AppTextStyles.label),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Prepare a clean, private match flow.',
            style: AppTextStyles.title,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This setup is designed for one-device multiplayer. Names, hints, and protected secret-tag selection stay clear before the live deduction phase begins.',
            style: AppTextStyles.subtitle.copyWith(height: 1.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoPill(icon: Icons.shield_outlined, label: 'Protected turns'),
              _InfoPill(
                icon: Icons.groups_2_outlined,
                label: 'Shared character pool',
              ),
              _InfoPill(
                icon: Icons.lightbulb_outline,
                label: '$hints hints each',
              ),
              _InfoPill(icon: Icons.flag_outlined, label: 'No life system'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerSetupCard extends StatelessWidget {
  const _PlayerSetupCard({
    required this.title,
    required this.helper,
    required this.icon,
    required this.accent,
    required this.controller,
    required this.label,
    required this.onChanged,
  });

  final String title;
  final String helper;
  final IconData icon;
  final Color accent;
  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.title.copyWith(fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: controller,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: label,
              helperText: helper,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _HintsSetupCard extends StatelessWidget {
  const _HintsSetupCard({required this.hints, required this.onChanged});

  final int hints;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hint budget', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Each player starts with $hints private hint${hints == 1 ? '' : 's'}. Hints reveal direction, not the exact answer.',
            style: AppTextStyles.subtitle.copyWith(height: 1.45),
          ),
          const SizedBox(height: AppSpacing.md),
          Slider(
            value: hints.toDouble(),
            min: GameConstants.minHints.toDouble(),
            max: GameConstants.maxHints.toDouble(),
            divisions: GameConstants.maxHints - GameConstants.minHints,
            label: '$hints',
            onChanged: (value) => onChanged(value.round()),
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              GameConstants.maxHints - GameConstants.minHints + 1,
              (index) {
                final hintValue = GameConstants.minHints + index;
                return ChoiceChip(
                  label: Text('$hintValue hint${hintValue == 1 ? '' : 's'}'),
                  selected: hints == hintValue,
                  onSelected: (_) => onChanged(hintValue),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchPreviewCard extends StatelessWidget {
  const _MatchPreviewCard({
    required this.playerOneName,
    required this.playerTwoName,
    required this.hints,
  });

  final String playerOneName;
  final String playerTwoName;
  final int hints;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Match preview', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.md),
          _PreviewRow(label: 'Player one', value: playerOneName),
          const SizedBox(height: AppSpacing.sm),
          _PreviewRow(label: 'Player two', value: playerTwoName),
          const SizedBox(height: AppSpacing.sm),
          _PreviewRow(label: 'Hints per player', value: '$hints'),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'Secret tags stay protected after this screen. The device is passed between players before private information is revealed again.',
              style: AppTextStyles.subtitle.copyWith(height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.secondary),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
