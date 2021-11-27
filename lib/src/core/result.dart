class Result<Value, Exception> {
  final Value? _value;
  final Exception? _exception;

  const Result({Value? value, Exception? exception})
      : _value = value,
        _exception = exception;

  const Result.success(final Value value)
      : _exception = null,
        _value = value;

  const Result.failed(final Exception exception)
      : _exception = exception,
        _value = null;

  Value? get valueOrNull => _value;
  Exception? get exceptionOrNull => _exception;

  Value get value {
    assert(_value != null, 'Make sure value isn\'t null');
    return _value!;
  }

  Exception get exception {
    assert(_exception != null, 'Make sure exception isn\'t null');
    return _exception!;
  }
}
