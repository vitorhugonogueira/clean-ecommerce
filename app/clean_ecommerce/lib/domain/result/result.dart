class Result<T> {
  final T? _content;
  final String? _errorMessage;

  Result._(this._content, this._errorMessage);

  factory Result.success(T content) => Result._(content, null);
  factory Result.failure(String errorMessage) => Result._(null, errorMessage);

  T? get content {
    return _content;
  }

  String? get errorMessage {
    return _errorMessage;
  }

  bool get isSuccess => _errorMessage == null;
  bool get isFailure => _errorMessage != null;
}
