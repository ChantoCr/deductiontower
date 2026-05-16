class MockAiRefereeDataSource {
  Future<String> getHintMessage() async {
    return 'The hidden trait is related to how the character looks.';
  }

  Future<String> getExplanationMessage() async {
    return 'That guess narrowed the search space without revealing the answer.';
  }
}
