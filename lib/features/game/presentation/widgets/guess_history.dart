import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/game/presentation/models/guess_history_entry.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class GuessHistory extends StatefulWidget {
  const GuessHistory({
    required this.entries,
    this.title = 'Public Match Timeline',
    this.description =
        'Recent shared information stays visible here so both players can track the deduction trail.',
    this.collapsedCount = 4,
    this.emptyStateMessage = 'No public events recorded yet.',
    super.key,
  });

  final List<GuessHistoryEntry> entries;
  final String title;
  final String description;
  final int collapsedCount;
  final String emptyStateMessage;

  @override
  State<GuessHistory> createState() => _GuessHistoryState();
}

class _GuessHistoryState extends State<GuessHistory> {
  _GuessHistoryFilter _selectedFilter = _GuessHistoryFilter.all;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final filteredEntries = widget.entries
        .where((entry) => _selectedFilter.matches(entry))
        .toList();
    final visibleEntries = _isExpanded
        ? filteredEntries
        : filteredEntries.take(widget.collapsedCount).toList();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(widget.title, style: AppTextStyles.title)),
              _HistoryCountPill(
                label: '${filteredEntries.length}/${widget.entries.length}',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.description,
            style: AppTextStyles.subtitle.copyWith(height: 1.45),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _GuessHistoryFilter.values.map((filter) {
              final count = widget.entries.where(filter.matches).length;
              return ChoiceChip(
                label: Text('${filter.label} $count'),
                selected: _selectedFilter == filter,
                onSelected: (_) {
                  setState(() {
                    _selectedFilter = filter;
                    _isExpanded = false;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: filteredEntries.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Text(
                      widget.emptyStateMessage,
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Column(
                    children: visibleEntries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _GuessHistoryEventTile(entry: entry),
                          ),
                        )
                        .toList(),
                  ),
          ),
          if (filteredEntries.length > widget.collapsedCount) ...[
            const SizedBox(height: AppSpacing.xs),
            Align(
              child: TextButton.icon(
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                icon: Icon(
                  _isExpanded
                      ? Icons.unfold_less_rounded
                      : Icons.unfold_more_rounded,
                ),
                label: Text(
                  _isExpanded
                      ? 'Collapse timeline'
                      : 'Show ${filteredEntries.length - visibleEntries.length} more events',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _GuessHistoryFilter {
  all,
  characterGuesses,
  traitGuesses,
  correctOnly,
  incorrectOnly,
  utility,
}

extension on _GuessHistoryFilter {
  String get label {
    switch (this) {
      case _GuessHistoryFilter.all:
        return 'All';
      case _GuessHistoryFilter.characterGuesses:
        return 'Characters';
      case _GuessHistoryFilter.traitGuesses:
        return 'Tags';
      case _GuessHistoryFilter.correctOnly:
        return 'Correct';
      case _GuessHistoryFilter.incorrectOnly:
        return 'Incorrect';
      case _GuessHistoryFilter.utility:
        return 'Utility';
    }
  }

  bool matches(GuessHistoryEntry entry) {
    switch (this) {
      case _GuessHistoryFilter.all:
        return true;
      case _GuessHistoryFilter.characterGuesses:
        return entry.isCharacterGuess;
      case _GuessHistoryFilter.traitGuesses:
        return entry.isTraitGuess;
      case _GuessHistoryFilter.correctOnly:
        return entry.isCorrectGuess;
      case _GuessHistoryFilter.incorrectOnly:
        return entry.isIncorrectGuess;
      case _GuessHistoryFilter.utility:
        return entry.isUtilityEvent;
    }
  }
}

class _HistoryCountPill extends StatelessWidget {
  const _HistoryCountPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _GuessHistoryEventTile extends StatefulWidget {
  const _GuessHistoryEventTile({required this.entry});

  final GuessHistoryEntry entry;

  @override
  State<_GuessHistoryEventTile> createState() => _GuessHistoryEventTileState();
}

class _GuessHistoryEventTileState extends State<_GuessHistoryEventTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final event = widget.entry;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        scale: _isHovered ? 1.01 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: event.color.withValues(alpha: _isHovered ? 0.12 : 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: event.color.withValues(alpha: 0.2)),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: event.color.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: event.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(event.icon, color: event.color),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _EventTypeBadge(entry: event),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(event.subtitle, style: AppTextStyles.subtitle),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventTypeBadge extends StatelessWidget {
  const _EventTypeBadge({required this.entry});

  final GuessHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _labelFor(entry),
        style: AppTextStyles.label.copyWith(fontSize: 11),
      ),
    );
  }

  String _labelFor(GuessHistoryEntry entry) {
    switch (entry.actionType) {
      case TurnActionType.guessCharacter:
        return entry.wasCorrect == true ? 'CHARACTER ✓' : 'CHARACTER';
      case TurnActionType.guessTrait:
        return entry.wasCorrect == true ? 'TAG ✓' : 'TAG';
      case TurnActionType.requestHint:
        return 'HINT';
      case TurnActionType.surrender:
        return 'SURRENDER';
      case TurnActionType.pass:
        return 'PASS';
    }
  }
}
