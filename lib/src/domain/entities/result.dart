typedef ResultFuture<T> = Future<Result<T>>;
typedef ResultVoid = ResultFuture<void>;

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;

  @override
  bool operator ==(Object other) {
    return other is Success &&
        other.runtimeType == runtimeType &&
        value == other.value;
  }

  @override
  int get hashCode => value.hashCode;
}

class Failure<T> extends Result<T> {
  const Failure(this.exception);
  final Exception exception;

  @override
  bool operator ==(Object other) {
    return other is Failure &&
        other.runtimeType == runtimeType &&
        exception == other.exception;
  }

  @override
  int get hashCode => exception.hashCode;
}

// * Extension
extension ResultExtension<T> on Result<T> {
  R when<R>(
    R Function(Success<T> success) actionSuccess,
    R Function(Failure<T> failure) actionFailure,
  ) {
    switch (this) {
      case Success<T>():
        return actionSuccess(this as Success<T>);

      case Failure<T>():
        return actionFailure(this as Failure<T>);
    }
  }

  bool get isFailure => this is Failure<T>;
  bool get isSuccess => this is Success<T>;

  R? whenSuccess<R>(R Function(Success<T> success) action) {
    if (this is Success<T>) {
      return action(this as Success<T>);
    }

    return null;
  }

  R? whenFailure<R>(R Function(Failure<T> failure) action) {
    if (this is Failure<T>) {
      return action(this as Failure<T>);
    }

    return null;
  }

  Exception getException() {
    assert(
      isFailure,
      'It should only be used when you are sure that it was failure',
    );

    return (this as Failure<T>).exception;
  }

  T getSuccessValue() {
    assert(
      isSuccess,
      'It should only be used when you are sure that it was successful',
    );

    return (this as Success<T>).value;
  }
}
