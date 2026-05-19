import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterLibraryState {
  const CharacterLibraryState({
    this.selectedTagId,
    this.selectedDifficulty,
    this.searchQuery = '',
  });

  final String? selectedTagId;
  final DifficultyLevel? selectedDifficulty;
  final String searchQuery;

  bool get hasFilters =>
      selectedTagId != null || selectedDifficulty != null || searchQuery.isNotEmpty;

  CharacterLibraryState copyWith({
    String? selectedTagId,
    DifficultyLevel? selectedDifficulty,
    String? searchQuery,
    bool clearTag = false,
    bool clearDifficulty = false,
    bool clearSearchQuery = false,
  }) {
    return CharacterLibraryState(
      selectedTagId: clearTag ? null : selectedTagId ?? this.selectedTagId,
      selectedDifficulty: clearDifficulty
          ? null
          : selectedDifficulty ?? this.selectedDifficulty,
      searchQuery: clearSearchQuery ? '' : searchQuery ?? this.searchQuery,
    );
  }
}

class CharacterLibraryController extends StateNotifier<CharacterLibraryState> {
  CharacterLibraryController() : super(const CharacterLibraryState());

  void selectTag(String tagId) {
    state = state.selectedTagId == tagId
        ? state.copyWith(clearTag: true)
        : state.copyWith(selectedTagId: tagId);
  }

  void selectDifficulty(DifficultyLevel difficulty) {
    state = state.selectedDifficulty == difficulty
        ? state.copyWith(clearDifficulty: true)
        : state.copyWith(selectedDifficulty: difficulty);
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value.trim());
  }

  void clearFilters() {
    state = const CharacterLibraryState();
  }
}

final characterLibraryControllerProvider =
    StateNotifierProvider<CharacterLibraryController, CharacterLibraryState>(
  (ref) => CharacterLibraryController(),
);
