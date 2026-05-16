class IdGenerator {
  const IdGenerator._();

  static String next(String prefix) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return '${prefix}_$timestamp';
  }
}
