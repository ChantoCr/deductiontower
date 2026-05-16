import 'package:anime_deduction_tower/features/ai_referee/domain/entities/ai_explanation.dart';
import 'package:anime_deduction_tower/features/ai_referee/domain/entities/ai_hint.dart';

abstract class AiRefereeRepository {
  Future<AiHint> getHint();
  Future<AiExplanation> getExplanation();
}
