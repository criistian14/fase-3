import 'package:dio/dio.dart';
import 'package:fake_store_client/src/infrastructure/infrastructure.dart';

typedef ResponseHTTP<T> = Response<T>;

/// [HttpMethods] is an enum that defines the possible HTTP methods
/// that can be used for making requests.
enum HttpMethods {
  /// The GET method requests a representation of the specified resource.
  get,

  /// The POST method is used to submit an entity to the specified resource.
  post,

  /// The PUT method replaces all current representations of the target resource
  /// with the request payload.
  put,

  /// The DELETE method deletes the specified resource.
  delete,

  /// The PATCH method is used to apply partial modifications to a resource.
  patch,
}

/// [ClientHelper] is an abstract class that defines the interface
/// for a client helper that facilitates making HTTP requests.
abstract class ClientHelper {
  /// The base URL for the HTTP requests.
  String get baseUrl;

  /// The timeout for the HTTP requests, in seconds.
  int get timeoutSeg;

  /// Makes an HTTP request to the specified endpoint.
  ///
  /// Parameters:
  /// - [endpoint]: The endpoint of the resource to be requested.
  /// - [name]: A name identifier for the request, used for logging or tracking.
  /// - [method]: The HTTP method to be used for the request,
  ///             defaults to [HttpMethods.get].
  ///
  /// Returns a [Future] containing a tuple with:
  /// - An [int] representing the HTTP status code of the response.
  /// - An optional [T] representing the response body, if any.
  ///
  /// Throws an exception if there is an error during make request like
  /// [ConnectionTimeoutError], [EndPointError] etc..
  ///
  /// Example usage:
  /// ```dart
  /// final (code, response) = await clientHelper.makeRequest<List<Map>>(
  ///   endpoint: '/products',
  ///   name: 'GetProducts',
  /// );
  ///
  /// final statusCode = code;
  /// final products = response;
  /// ```
  Future<(int, T?)> makeRequest<T>({
    required String endpoint,
    required String name,
    HttpMethods method = HttpMethods.get,
  });
}

class ClientHelperImpl implements ClientHelper {
  ClientHelperImpl({
    required Dio client,
  }) : _client = client {
    _client.options.baseUrl = baseUrl;
    _client.options.connectTimeout = Duration(seconds: timeoutSeg);
  }

  final Dio _client;

  @override
  String get baseUrl => 'https://fakestoreapi.com/';

  @override
  int get timeoutSeg => 50;

  static const _defaultHeaders = <String, String>{
    'Accept': 'application/json',
    'Content-type': 'application/json',
  };

  @override
  Future<(int, T?)> makeRequest<T>({
    required String endpoint,
    required String name,
    HttpMethods method = HttpMethods.get,
  }) async {
    ResponseHTTP<T?>? response;

    try {
      response = await _client.request<T?>(
        endpoint,
        options: Options(
          method: method.name.toUpperCase(),
          headers: _defaultHeaders,
        ),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw ConnectionTimeoutError(endpoint: name);
      }

      throw EndPointError(
        code: e.response?.statusCode ?? 0,
        endpoint: name,
        message: e.error.toString(),
      );
    } catch (_) {}

    return parseResponse(response, name);
  }

  (int, T?) parseResponse<T>(
    ResponseHTTP<T?>? response,
    String name,
  ) {
    if (response == null) {
      throw EndPointError(
        endpoint: name,
        code: 0,
      );
    }

    final code = response.statusCode ?? 0;
    final data = response.data;

    if (data == null) {
      return (code, null);
    }

    return (code, data);
  }
}
