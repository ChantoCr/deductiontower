import 'package:anime_deduction_tower/features/ai_referee/data/datasources/mock_ai_referee_datasource.dart';
import 'package:anime_deduction_tower/features/ai_referee/domain/entities/ai_explanation.dart';
import 'package:anime_deduction_tower/features/ai_referee/domain/entities/ai_hint.dart';
import 'package:anime_deduction_tower/features/ai_referee/domain/repositories/ai_referee_repository.dart';

class AiRefereeRepositoryImpl implements AiRefereeRepository {
  AiRefereeRepositoryImpl({MockAiRefereeDataSource? dataSource})
      : _dataSource = dataSource ?? MockAiRefereeDataSource();

  final MockAiRefereeDataSource _dataSource;

  @override
  Future<AiExplanation> getExplanation() async {
    final message = await _dataSource.getExplanationMessage();
    return AiExplanation(message: message);
  }

  @override
  Future<AiHint> getHint() async {
    final message = await _dataSource.getHintMessage();
    return AiHint(message: message);
  }
}
