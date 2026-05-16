import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterLibraryState {
  const CharacterLibraryState({
    this.selectedTagId,
    this.selectedDifficulty,
  });

  final String? selectedTagId;
  final DifficultyLevel? selectedDifficulty;

  bool get hasFilters => selectedTagId != null || selectedDifficulty != null;

  CharacterLibraryState copyWith({
    String? selectedTagId,
    DifficultyLevel? selectedDifficulty,
    bool clearTag = false,
    bool clearDifficulty = false,
  }) {
    return CharacterLibraryState(
      selectedTagId: clearTag ? null : selectedTagId ?? this.selectedTagId,
      selectedDifficulty: clearDifficulty
          ? null
          : selectedDifficulty ?? this.selectedDifficulty,
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

  void clearFilters() {
    state = const CharacterLibraryState();
  }
}

final characterLibraryControllerProvider =
    StateNotifierProvider<CharacterLibraryController, CharacterLibraryState>(
  (ref) => CharacterLibraryController(),
);
