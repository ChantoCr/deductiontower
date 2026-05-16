import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySelectionState {
  const CategorySelectionState({
    this.currentPlayerNumber = 1,
    this.playerOneTraitId,
    this.playerTwoTraitId,
  });

  final int currentPlayerNumber;
  final String? playerOneTraitId;
  final String? playerTwoTraitId;

  bool get isSelectingPlayerOne => currentPlayerNumber == 1;

  String? get currentSelectedTraitId =>
      isSelectingPlayerOne ? playerOneTraitId : playerTwoTraitId;

  bool get canConfirmCurrentSelection => currentSelectedTraitId != null;

  bool get isComplete => playerOneTraitId != null && playerTwoTraitId != null;

  CategorySelectionState copyWith({
    int? currentPlayerNumber,
    String? playerOneTraitId,
    String? playerTwoTraitId,
  }) {
    return CategorySelectionState(
      currentPlayerNumber: currentPlayerNumber ?? this.currentPlayerNumber,
      playerOneTraitId: playerOneTraitId ?? this.playerOneTraitId,
      playerTwoTraitId: playerTwoTraitId ?? this.playerTwoTraitId,
    );
  }
}

class CategorySelectionController extends StateNotifier<CategorySelectionState> {
  CategorySelectionController() : super(const CategorySelectionState());

  void selectTrait(String traitId) {
    if (state.isSelectingPlayerOne) {
      state = state.copyWith(playerOneTraitId: traitId);
      return;
    }

    state = state.copyWith(playerTwoTraitId: traitId);
  }

  void confirmCurrentSelection() {
    if (!state.canConfirmCurrentSelection) {
      return;
    }

    if (state.isSelectingPlayerOne) {
      state = state.copyWith(currentPlayerNumber: 2);
    }
  }

  void reset() {
    state = const CategorySelectionState();
  }
}

final categorySelectionControllerProvider =
    StateNotifierProvider<CategorySelectionController, CategorySelectionState>(
  (ref) => CategorySelectionController(),
);
