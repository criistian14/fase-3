import 'dart:io';

/// [NetworkHelper] is an abstract class that defines the interface
/// for checking network connectivity status.
abstract class NetworkHelper {
  /// Checks if the device is connected to the internet.
  ///
  /// Returns a [Future] containing a [bool] that is `true` if the device
  /// is connected to the internet, and `false` otherwise.
  ///
  /// This method may throw an error if the connectivity check fails
  /// due to network issues or other unexpected errors.
  ///
  /// Example usage:
  /// ```dart
  /// final isConnected = await networkHelper.isConnected;
  /// if (isConnected) {
  ///   print('Device is connected to the internet');
  /// } else {
  ///   print('Device is not connected to the internet');
  /// }
  /// ```
  Future<bool> get isConnected;
}

class NetworkHelperImpl implements NetworkHelper {
  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }

    return false;
  }
}
