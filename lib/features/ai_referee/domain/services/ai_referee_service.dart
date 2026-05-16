import 'package:anime_deduction_tower/features/ai_referee/domain/entities/ai_explanation.dart';
import 'package:anime_deduction_tower/features/ai_referee/domain/entities/ai_hint.dart';
import 'package:anime_deduction_tower/features/ai_referee/domain/repositories/ai_referee_repository.dart';

class AiRefereeService {
  const AiRefereeService(this.repository);

  final AiRefereeRepository repository;

  Future<AiHint> requestHint() => repository.getHint();
  Future<AiExplanation> requestExplanation() => repository.getExplanation();
}
