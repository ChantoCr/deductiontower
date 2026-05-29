import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/category_selection_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/game_setup_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/providers/trait_category_providers.dart';
import 'package:anime_deduction_tower/shared/animations/pulse_animation.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_dialog.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategorySelectionScreen extends ConsumerStatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  ConsumerState<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState
    extends ConsumerState<CategorySelectionScreen> {
  late final TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalogAsync = ref.watch(validatedTraitCatalogProvider);
    final charactersAsync = ref.watch(charactersProvider);
    final selectionState = ref.watch(categorySelectionControllerProvider);
    final setupState = ref.watch(gameSetupControllerProvider);
    final controller = ref.read(categorySelectionControllerProvider.notifier);

    return catalogAsync.when(
      data: (catalog) {
        final characterTagCounts = charactersAsync.maybeWhen(
          data: (characters) {
            final counts = <String, int>{};
            for (final character in characters) {
              for (final tag in character.tags) {
                counts[tag] = (counts[tag] ?? 0) + 1;
              }
            }
            return counts;
          },
          orElse: () => const <String, int>{},
        );

        final categories = [...catalog.validCategories]
          ..sort((a, b) => a.label.compareTo(b.label));

        final filteredCategories = categories.where((category) {
          final query = _searchQuery.trim().toLowerCase();
          if (query.isEmpty) {
            return true;
          }

          return category.label.toLowerCase().contains(query) ||
              category.hintType.toLowerCase().contains(query);
        }).toList();
        TraitCategory? selectedCategory;
        final selectedId = selectionState.currentSelectedTraitId;
        if (selectedId != null) {
          for (final category in categories) {
            if (category.id == selectedId) {
              selectedCategory = category;
              break;
            }
          }
        }

        final lockedSelections = selectionState.isPlayerVsAi
            ? selectionState.isComplete
                ? 2
                : selectionState.playerOneTraitId == null
                    ? 0
                    : 1
            : [
                selectionState.playerOneTraitId,
                selectionState.playerTwoTraitId,
              ].whereType<String>().length;

        return AppScaffold(
          title: 'Secret Tag Selection',
          bottomBar: _CategorySelectionActionBar(
            selectionState: selectionState,
            selectedCategory: selectedCategory,
            setupState: setupState,
            onConfirm: selectionState.canConfirmCurrentSelection
                ? () async {
                    if (selectionState.isSelectingPlayerOne &&
                        !selectionState.isPlayerVsAi) {
                      controller.confirmCurrentSelection();
                      await AppDialog.showInfo(
                        context,
                        title: 'Player 1 Tag Saved',
                        message:
                            'Pass the device to Player 2 and choose the next hidden tag.',
                      );
                      return;
                    }

                    if (selectionState.isSelectingPlayerOne &&
                        selectionState.isPlayerVsAi) {
                      controller.confirmCurrentSelection();
                      await AppDialog.showInfo(
                        context,
                        title: 'Your Tag Is Locked',
                        message:
                            '${setupState.playerTwoName} will receive an auto-assigned hidden tag when the match starts.',
                      );
                      return;
                    }

                    controller.confirmCurrentSelection();
                  }
                : null,
            onContinue: selectionState.isComplete
                ? () => context.go(AppRoutes.turnTransition)
                : null,
            onReset: controller.reset,
          ),
          child: ListView(
            children: [
              _SelectionHeroCard(
                selectionState: selectionState,
                totalCategories: categories.length,
                filteredCategories: filteredCategories.length,
                lockedSelections: lockedSelections,
                setupState: setupState,
              ),
              if (catalog.hasIssues) ...[
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  glowColor: AppColors.accent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Catalog validation warnings',
                        style: AppTextStyles.title,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...catalog.issues.map(
                        (issue) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('• ${issue.message}'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              AppCard(
                glowColor: AppColors.secondary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Find a secret tag', style: AppTextStyles.title),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Search by tag label or hint type, then tap a card to stage the private pick for the active player.',
                      style: AppTextStyles.subtitle.copyWith(height: 1.45),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _searchController,
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        labelText: 'Search tags',
                        hintText: 'Search by tag label or hint type',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.trim().isEmpty
                            ? null
                            : IconButton(
                                onPressed: _clearSearch,
                                icon: const Icon(Icons.close),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (filteredCategories.isEmpty)
                const AppCard(
                  child: Text('No tags match the current search.'),
                )
              else
                ...filteredCategories.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;
                  final isSelected =
                      selectionState.currentSelectedTraitId == category.id;
                  final count = characterTagCounts[category.tagId] ?? 0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _CategorySelectionTile(
                      category: category,
                      count: count,
                      index: index,
                      isSelected: isSelected,
                      playerNumber: selectionState.currentPlayerNumber,
                      isPlayerVsAi: selectionState.isPlayerVsAi,
                      onTap: () => controller.selectTrait(category.id),
                    ),
                  );
                }),
              const SizedBox(height: 200),
            ],
          ),
        );
      },
      loading: () => const AppScaffold(
        title: 'Secret Tag Selection',
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => AppScaffold(
        title: 'Secret Tag Selection',
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Failed to Load Tags', style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.sm),
              Text('$error'),
            ],
          ),
        ),
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }
}

class _SelectionHeroCard extends StatelessWidget {
  const _SelectionHeroCard({
    required this.selectionState,
    required this.totalCategories,
    required this.filteredCategories,
    required this.lockedSelections,
    required this.setupState,
  });

  final CategorySelectionState selectionState;
  final int totalCategories;
  final int filteredCategories;
  final int lockedSelections;
  final GameSetupState setupState;

  @override
  Widget build(BuildContext context) {
    final isComplete = selectionState.isComplete;
    final activeGlow = isComplete ? AppColors.success : AppColors.secondary;

    return AppCard(
      glowColor: activeGlow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PulseAnimation(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: activeGlow.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isComplete
                        ? Icons.verified_user_outlined
                        : Icons.lock_person_outlined,
                    color: activeGlow,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'PRIVATE PICK',
                        style: AppTextStyles.label,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: Column(
                        key: ValueKey(
                          '${selectionState.currentPlayerNumber}-${selectionState.isComplete}',
                        ),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isComplete
                                ? selectionState.isPlayerVsAi
                                    ? 'Your hidden tag is locked. ${setupState.playerTwoName} is ready.'
                                    : 'Both hidden tags are locked in.'
                                : selectionState.isPlayerVsAi
                                    ? 'Choose your hidden tag.'
                                    : 'Choose the hidden tag for Player ${selectionState.currentPlayerNumber}.',
                            style: AppTextStyles.title,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            isComplete
                                ? selectionState.isPlayerVsAi
                                    ? 'Secret selection is ready. Continue to the transition screen, then let ${setupState.playerTwoName} take automated public turns.'
                                    : 'Secret selection is ready. Continue to the protected handoff before revealing the live match.'
                                : selectionState.isPlayerVsAi
                                    ? 'Only you should be looking at the screen. The AI hidden tag will be assigned automatically after you lock your choice.'
                                    : selectionState.isSelectingPlayerOne
                                        ? 'Player 1 is choosing privately. Only the active player should be looking at the screen.'
                                        : 'Player 2 is choosing privately. Keep the device hidden from the opponent.',
                            style:
                                AppTextStyles.subtitle.copyWith(height: 1.45),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SelectionStageTrack(selectionState: selectionState),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SelectionPill(
                icon: Icons.person_outline,
                label: selectionState.isComplete
                    ? selectionState.isPlayerVsAi
                        ? 'Human vs AI ready'
                        : '2 players ready'
                    : selectionState.isPlayerVsAi
                        ? '${setupState.playerOneName} selecting'
                        : 'Player ${selectionState.currentPlayerNumber} selecting',
              ),
              _SelectionPill(
                icon: Icons.style_outlined,
                label: '$totalCategories playable tags',
              ),
              _SelectionPill(
                icon: Icons.search,
                label: '$filteredCategories shown',
              ),
              _SelectionPill(
                icon: Icons.lock_outline,
                label: '$lockedSelections / 2 locked',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectionStageTrack extends StatelessWidget {
  const _SelectionStageTrack({required this.selectionState});

  final CategorySelectionState selectionState;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StageNode(
            title: selectionState.isPlayerVsAi ? 'You' : 'Player 1',
            subtitle: selectionState.playerOneTraitId == null
                ? 'Waiting'
                : selectionState.isSelectingPlayerOne &&
                        !selectionState.isComplete
                    ? 'Selected now'
                    : 'Locked',
            isActive: selectionState.isSelectingPlayerOne &&
                !selectionState.isComplete,
            isDone: selectionState.playerOneTraitId != null,
          ),
        ),
        Container(
          width: 28,
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: selectionState.playerOneTraitId != null
              ? AppColors.secondary.withValues(alpha: 0.5)
              : AppColors.primary.withValues(alpha: 0.18),
        ),
        Expanded(
          child: _StageNode(
            title: selectionState.isPlayerVsAi ? 'Tower AI' : 'Player 2',
            subtitle: selectionState.isPlayerVsAi
                ? selectionState.isComplete
                    ? 'Auto-assigned'
                    : 'Auto later'
                : selectionState.playerTwoTraitId == null
                    ? selectionState.isSelectingPlayerOne
                        ? 'Next up'
                        : 'Choosing'
                    : 'Locked',
            isActive: !selectionState.isPlayerVsAi &&
                !selectionState.isSelectingPlayerOne &&
                !selectionState.isComplete,
            isDone: selectionState.isPlayerVsAi
                ? selectionState.isComplete
                : selectionState.playerTwoTraitId != null,
          ),
        ),
      ],
    );
  }
}

class _StageNode extends StatelessWidget {
  const _StageNode({
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.isDone,
  });

  final String title;
  final String subtitle;
  final bool isActive;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final color = isDone
        ? AppColors.success
        : isActive
            ? AppColors.secondary
            : AppColors.muted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isActive ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDone
                  ? Icons.check_rounded
                  : isActive
                      ? Icons.visibility_outlined
                      : Icons.more_horiz_rounded,
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.subtitle.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySelectionTile extends StatefulWidget {
  const _CategorySelectionTile({
    required this.category,
    required this.count,
    required this.index,
    required this.isSelected,
    required this.playerNumber,
    required this.isPlayerVsAi,
    required this.onTap,
  });

  final TraitCategory category;
  final int count;
  final int index;
  final bool isSelected;
  final int playerNumber;
  final bool isPlayerVsAi;
  final VoidCallback onTap;

  @override
  State<_CategorySelectionTile> createState() => _CategorySelectionTileState();
}

class _CategorySelectionTileState extends State<_CategorySelectionTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.isSelected ? AppColors.secondary : AppColors.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        scale: _isHovered ? 1.01 : 1,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: widget.onTap,
            child: AppCard(
              glowColor: accent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: accent.withValues(
                            alpha: widget.isSelected
                                ? 0.2
                                : _isHovered
                                    ? 0.14
                                    : 0.1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${widget.index + 1}',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.category.label,
                              style: AppTextStyles.title.copyWith(fontSize: 20),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.isSelected
                                  ? widget.isPlayerVsAi
                                      ? 'Selected for your hidden tag. Lock it below when ready, then the AI tag will be assigned automatically.'
                                      : 'Selected for Player ${widget.playerNumber}. Lock it below when ready.'
                                  : widget.isPlayerVsAi
                                      ? 'Tap to privately stage this hidden tag for yourself.'
                                      : 'Tap to privately stage this tag for Player ${widget.playerNumber}.',
                              style: AppTextStyles.subtitle.copyWith(
                                color: widget.isSelected
                                    ? AppColors.text
                                    : AppColors.muted,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: widget.isSelected
                            ? Container(
                                key: const ValueKey('selected'),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.success.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'Selected',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            : Icon(
                                _isHovered
                                    ? Icons.touch_app_rounded
                                    : Icons.arrow_forward_ios_rounded,
                                key: ValueKey('hover-${_isHovered.toString()}'),
                                size: 18,
                                color: _isHovered
                                    ? AppColors.secondary
                                    : AppColors.muted,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _SelectionMeta(
                        label: 'Type',
                        value: widget.category.hintType,
                      ),
                      _SelectionMeta(
                        label: 'Difficulty',
                        value: widget.category.difficulty.name,
                      ),
                      _SelectionMeta(
                        label: 'Characters',
                        value: '${widget.count}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionPill extends StatelessWidget {
  const _SelectionPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.16)),
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

class _SelectionMeta extends StatelessWidget {
  const _SelectionMeta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '$label: $value',
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _CategorySelectionActionBar extends StatelessWidget {
  const _CategorySelectionActionBar({
    required this.selectionState,
    required this.onReset,
    required this.setupState,
    this.selectedCategory,
    this.onConfirm,
    this.onContinue,
  });

  final CategorySelectionState selectionState;
  final GameSetupState setupState;
  final TraitCategory? selectedCategory;
  final VoidCallback? onConfirm;
  final VoidCallback? onContinue;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final statusText = selectedCategory == null
        ? 'No tag selected yet.'
        : 'Selected: ${selectedCategory!.label}';

    return AppCard(
      glowColor:
          selectionState.isComplete ? AppColors.success : AppColors.secondary,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  selectionState.isComplete
                      ? selectionState.isPlayerVsAi
                          ? 'Player vs AI ready'
                          : 'Secret tags ready'
                      : selectionState.isPlayerVsAi
                          ? 'Your secret tag'
                          : selectionState.isSelectingPlayerOne
                              ? 'Player 1 selection'
                              : 'Player 2 selection',
                  style: AppTextStyles.title,
                ),
              ),
              if (selectedCategory != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    selectedCategory!.hintType,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              statusText,
              key: ValueKey(statusText),
              style: AppTextStyles.subtitle,
            ),
          ),
          if (selectedCategory != null) ...[
            const SizedBox(height: AppSpacing.md),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.22),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      selectionState.isComplete
                          ? selectionState.isPlayerVsAi
                              ? '${setupState.playerTwoName} will receive an auto-assigned hidden tag when the match begins.'
                              : 'Both private tags are locked and ready for the protected handoff.'
                          : selectionState.isPlayerVsAi
                              ? 'This selection is staged privately for your hidden tag.'
                              : 'This selection is staged privately for Player ${selectionState.currentPlayerNumber}.',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (!selectionState.isComplete)
            AppButton(
              label: selectionState.isPlayerVsAi
                  ? 'Lock Your Tag'
                  : selectionState.isSelectingPlayerOne
                      ? 'Lock Player 1 Tag'
                      : 'Save Player 2 Tag',
              icon: selectionState.isPlayerVsAi
                  ? Icons.smart_toy_outlined
                  : selectionState.isSelectingPlayerOne
                      ? Icons.lock_outline_rounded
                      : Icons.check_circle_outline_rounded,
              onPressed: onConfirm,
            )
          else ...[
            AppButton(
              label: 'Continue to Turn Transition',
              icon: Icons.swap_horiz_rounded,
              onPressed: onContinue,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Reset Secret Selection',
              icon: Icons.restart_alt_rounded,
              isPrimary: false,
              onPressed: onReset,
            ),
          ],
        ],
      ),
    );
  }
}
