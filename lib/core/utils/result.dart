class Result<T> {
  const Result._({this.data, this.error});

  const Result.success(T data) : this._(data: data);
  const Result.failure(String error) : this._(error: error);

  final T? data;
  final String? error;

  bool get isSuccess => error == null;
}
