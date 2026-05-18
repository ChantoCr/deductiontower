import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/core/constants/game_constants.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/category_selection_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/game_setup_controller.dart';
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
    _playerOneController = TextEditingController(text: setupState.playerOneName);
    _playerTwoController = TextEditingController(text: setupState.playerTwoName);
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
      title: 'Game Setup',
      child: ListView(
        children: [
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Local Multiplayer Setup', style: AppTextStyles.title),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Set player names and hint count before moving into protected secret trait selection. This match format does not use lives.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Players', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _playerOneController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Player 1 Name',
                    helperText: 'Used in the turn panel, result screen, and turn transitions.',
                  ),
                  onChanged: controller.updatePlayerOneName,
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _playerTwoController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Player 2 Name',
                    helperText: 'Names are trimmed automatically and never left blank.',
                  ),
                  onChanged: controller.updatePlayerTwoName,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hints Per Player', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${setupState.hints} selected',
                  style: AppTextStyles.subtitle,
                ),
                Slider(
                  value: setupState.hints.toDouble(),
                  min: GameConstants.minHints.toDouble(),
                  max: GameConstants.maxHints.toDouble(),
                  divisions: GameConstants.maxHints - GameConstants.minHints,
                  label: '${setupState.hints}',
                  onChanged: (value) => controller.updateHints(value.round()),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    GameConstants.maxHints - GameConstants.minHints + 1,
                    (index) {
                      final hintValue = GameConstants.minHints + index;
                      return ChoiceChip(
                        label: Text('$hintValue hint${hintValue == 1 ? '' : 's'}'),
                        selected: setupState.hints == hintValue,
                        onSelected: (_) => controller.updateHints(hintValue),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Match Preview', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.sm),
                Text('Player 1: ${setupState.playerOneName}'),
                Text('Player 2: ${setupState.playerTwoName}'),
                Text('Hints per player: ${setupState.hints}'),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Secret traits stay protected. The device will be passed between players before any private information is revealed.',
                  style: AppTextStyles.subtitle,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Continue to Secret Selection',
            icon: Icons.arrow_forward,
            onPressed: () {
              controller.updatePlayerNames(
                playerOneName: _playerOneController.text,
                playerTwoName: _playerTwoController.text,
              );
              ref.read(categorySelectionControllerProvider.notifier).reset();
              context.go(AppRoutes.categorySelection);
            },
          ),
        ],
      ),
    );
  }
}
