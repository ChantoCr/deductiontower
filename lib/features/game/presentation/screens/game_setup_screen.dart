import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/core/constants/game_constants.dart';
import 'package:anime_deduction_tower/core/enums/ai_difficulty.dart';
import 'package:anime_deduction_tower/core/enums/game_mode.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/category_selection_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/game_setup_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/game_flow_copy_helper.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/ai_opponent_profile_card.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_badge.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:anime_deduction_tower/shared/widgets/app_summary_card.dart';
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
    const copy = GameFlowCopyHelper();
    final setupState = ref.watch(gameSetupControllerProvider);
    final controller = ref.read(gameSetupControllerProvider.notifier);

    if (_playerOneController.text != setupState.playerOneName) {
      _playerOneController.value = _playerOneController.value.copyWith(
        text: setupState.playerOneName,
        selection: TextSelection.collapsed(
          offset: setupState.playerOneName.length,
        ),
      );
    }

    if (_playerTwoController.text != setupState.playerTwoName) {
      _playerTwoController.value = _playerTwoController.value.copyWith(
        text: setupState.playerTwoName,
        selection: TextSelection.collapsed(
          offset: setupState.playerTwoName.length,
        ),
      );
    }

    return AppScaffold(
      title: setupState.isPlayerVsAi
          ? 'Player vs AI Setup'
          : 'Single Device Match',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useWidePlayersLayout = constraints.maxWidth >= 760;

          return ListView(
            children: [
              _SetupHeroCard(
                hints: setupState.hints,
                matchMode: setupState.matchMode,
                aiDifficulty: setupState.aiDifficulty,
              ),
              const SizedBox(height: AppSpacing.lg),
              _ModeSelectionCard(
                selectedMode: setupState.matchMode,
                onModeSelected: controller.updateMatchMode,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (setupState.isPlayerVsAi) ...[
                _AiDifficultyCard(
                  selectedDifficulty: setupState.aiDifficulty,
                  onDifficultySelected: controller.updateAiDifficulty,
                ),
                const SizedBox(height: AppSpacing.md),
                AiOpponentProfileCard(
                  aiName: setupState.playerTwoName,
                  difficulty: setupState.aiDifficulty,
                  title: 'AI opponent profile',
                  description: copy.aiOpponentSetupDescription(
                    aiName: setupState.playerTwoName,
                    difficulty: setupState.aiDifficulty,
                  ),
                  footer:
                      'Player vs AI keeps the same no-lives rules as local multiplayer: correct hidden-tag guess or surrender ends the match.',
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              Text(
                'Player identities',
                style: AppTextStyles.title.copyWith(fontSize: 22),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                copy.setupPlayersSectionDescription(
                  isPlayerVsAi: setupState.isPlayerVsAi,
                ),
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
                        helper: copy.playerNameHelper(1),
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
                        title: setupState.isPlayerVsAi
                            ? 'AI Opponent'
                            : 'Player Two',
                        helper: setupState.isPlayerVsAi
                            ? 'This name appears in AI-turn messaging, the timeline, and the result screen.'
                            : copy.playerNameHelper(2),
                        icon: setupState.isPlayerVsAi
                            ? Icons.smart_toy_outlined
                            : Icons.looks_two_rounded,
                        accent: AppColors.secondary,
                        controller: _playerTwoController,
                        label: setupState.isPlayerVsAi
                            ? 'AI opponent name'
                            : 'Player two name',
                        onChanged: controller.updatePlayerTwoName,
                      ),
                    ),
                  ],
                )
              else ...[
                _PlayerSetupCard(
                  title: 'Player One',
                  helper: copy.playerNameHelper(1),
                  icon: Icons.looks_one_rounded,
                  accent: AppColors.primary,
                  controller: _playerOneController,
                  label: 'Player one name',
                  onChanged: controller.updatePlayerOneName,
                ),
                const SizedBox(height: AppSpacing.md),
                _PlayerSetupCard(
                  title: setupState.isPlayerVsAi ? 'AI Opponent' : 'Player Two',
                  helper: setupState.isPlayerVsAi
                      ? 'This name appears in AI-turn messaging, the timeline, and the result screen.'
                      : copy.playerNameHelper(2),
                  icon: setupState.isPlayerVsAi
                      ? Icons.smart_toy_outlined
                      : Icons.looks_two_rounded,
                  accent: AppColors.secondary,
                  controller: _playerTwoController,
                  label: setupState.isPlayerVsAi
                      ? 'AI opponent name'
                      : 'Player two name',
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
                isPlayerVsAi: setupState.isPlayerVsAi,
                aiDifficulty: setupState.aiDifficulty,
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
                      .reset(isPlayerVsAi: setupState.isPlayerVsAi);
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
  const _SetupHeroCard({
    required this.hints,
    required this.matchMode,
    required this.aiDifficulty,
  });

  final int hints;
  final GameMode matchMode;
  final AiDifficulty aiDifficulty;

  @override
  Widget build(BuildContext context) {
    const copy = GameFlowCopyHelper();

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
            copy.setupHeroDescription(),
            style: AppTextStyles.subtitle.copyWith(height: 1.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppBadge(
                icon: Icons.shield_outlined,
                label: 'Protected turns',
                accent: AppColors.secondary,
                backgroundColor: AppColors.surface.withValues(alpha: 0.85),
                borderColor: AppColors.primary.withValues(alpha: 0.14),
              ),
              AppBadge(
                icon: Icons.groups_2_outlined,
                label: 'Shared character pool',
                accent: AppColors.secondary,
                backgroundColor: AppColors.surface.withValues(alpha: 0.85),
                borderColor: AppColors.primary.withValues(alpha: 0.14),
              ),
              AppBadge(
                icon: Icons.lightbulb_outline,
                label: '$hints hints each',
                accent: AppColors.secondary,
                backgroundColor: AppColors.surface.withValues(alpha: 0.85),
                borderColor: AppColors.primary.withValues(alpha: 0.14),
              ),
              AppBadge(
                icon: Icons.flag_outlined,
                label: 'No life system',
                accent: AppColors.secondary,
                backgroundColor: AppColors.surface.withValues(alpha: 0.85),
                borderColor: AppColors.primary.withValues(alpha: 0.14),
              ),
              if (matchMode == GameMode.playerVsAi)
                AppBadge(
                  icon: Icons.smart_toy_outlined,
                  label: '${aiDifficulty.label} AI',
                  accent: AppColors.accent,
                  backgroundColor: AppColors.surface.withValues(alpha: 0.85),
                  borderColor: AppColors.accent.withValues(alpha: 0.18),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeSelectionCard extends StatelessWidget {
  const _ModeSelectionCard({
    required this.selectedMode,
    required this.onModeSelected,
  });

  final GameMode selectedMode;
  final ValueChanged<GameMode> onModeSelected;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mode configuration', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(
            selectedMode == GameMode.playerVsAi
                ? 'Choose a human-vs-AI match. You lock your own hidden tag, then Tower AI receives an auto-assigned opponent tag and takes automated public turns.'
                : 'Choose classic one-device multiplayer. Both players still use protected secret selection and pass-the-device reveals.',
            style: AppTextStyles.subtitle.copyWith(height: 1.45),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ChoiceChip(
                label: const Text('Single Device Match'),
                selected: selectedMode == GameMode.localMultiplayer,
                onSelected: (_) => onModeSelected(GameMode.localMultiplayer),
              ),
              ChoiceChip(
                label: const Text('Play vs AI'),
                selected: selectedMode == GameMode.playerVsAi,
                onSelected: (_) => onModeSelected(GameMode.playerVsAi),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AiDifficultyCard extends StatelessWidget {
  const _AiDifficultyCard({
    required this.selectedDifficulty,
    required this.onDifficultySelected,
  });

  final AiDifficulty selectedDifficulty;
  final ValueChanged<AiDifficulty> onDifficultySelected;

  @override
  Widget build(BuildContext context) {
    const copy = GameFlowCopyHelper();

    return AppCard(
      glowColor: AppColors.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AI difficulty', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(
            copy.aiDifficultyDescription(selectedDifficulty),
            style: AppTextStyles.subtitle.copyWith(height: 1.45),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: AiDifficulty.values.map((difficulty) {
              return ChoiceChip(
                label: Text(difficulty.label),
                selected: selectedDifficulty == difficulty,
                onSelected: (_) => onDifficultySelected(difficulty),
              );
            }).toList(),
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
    const copy = GameFlowCopyHelper();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hint budget', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(
            copy.hintBudgetDescription(hints),
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
    required this.isPlayerVsAi,
    required this.aiDifficulty,
  });

  final String playerOneName;
  final String playerTwoName;
  final int hints;
  final bool isPlayerVsAi;
  final AiDifficulty aiDifficulty;

  @override
  Widget build(BuildContext context) {
    const copy = GameFlowCopyHelper();

    return AppSummaryCard(
      title: 'Match preview',
      items: [
        AppSummaryItem(
          label: isPlayerVsAi ? 'Human player' : 'Player one',
          value: playerOneName,
        ),
        AppSummaryItem(
          label: isPlayerVsAi ? 'AI opponent' : 'Player two',
          value: playerTwoName,
        ),
        AppSummaryItem(
          label: 'Mode',
          value: isPlayerVsAi ? 'Player vs AI' : 'Single device match',
        ),
        if (isPlayerVsAi)
          AppSummaryItem(label: 'AI difficulty', value: aiDifficulty.label),
        AppSummaryItem(label: 'Hints per player', value: '$hints'),
      ],
      footer: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          copy.matchPreviewPrivacyNote(
            isPlayerVsAi: isPlayerVsAi,
            aiDifficulty: aiDifficulty,
          ),
          style: AppTextStyles.subtitle.copyWith(height: 1.45),
        ),
      ),
    );
  }
}
