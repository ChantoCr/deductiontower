import 'package:anime_deduction_tower/features/ai_opponent/domain/services/ai_opponent_service.dart';
import 'package:anime_deduction_tower/features/ai_opponent/domain/services/mock_ai_opponent_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiOpponentServiceProvider = Provider<AiOpponentService>(
  (ref) => MockAiOpponentService(),
);
