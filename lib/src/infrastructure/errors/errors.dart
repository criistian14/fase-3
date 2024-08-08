class NoInternetConnectionError implements Exception {
  const NoInternetConnectionError();

  @override
  String toString() {
    return 'Lo sentimos, parece que no tienes conexión a internet';
  }
}

class ConnectionTimeoutError implements Exception {
  const ConnectionTimeoutError({
    required this.endpoint,
    this.time = 50,
  });

  final String endpoint;
  final int time;

  @override
  String toString() {
    return 'Ups, parece que tomo mas tiempo del previsto ($time seg) '
        '- $endpoint';
  }
}

class EndPointError implements Exception {
  const EndPointError({
    required this.code,
    required this.endpoint,
    this.message,
  });

  final int code;
  final String endpoint;
  final String? message;

  @override
  String toString() {
    return 'Ups, ocurrió un error al intentar procesar $endpoint - \n\n($code) '
        '$message';
  }
}

class EmptyDataError implements Exception {
  const EmptyDataError({
    required this.endpoint,
  });

  final String endpoint;

  @override
  String toString() {
    return 'Ups, parece que no obtuvimos nada de $endpoint';
  }
}
