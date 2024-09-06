/// A custom exception class for handling errors related to LogTail operations.
///
/// This class implements the [Exception] interface
/// and provides specific error messages
/// based on the HTTP status code returned by the LogTail server.
class LogTailException implements Exception {
  /// Creates a [LogTailException] with the provided HTTP [statusCode].
  ///
  /// The [statusCode] represents the HTTP response
  /// status code from the LogTail server,
  /// which is used to determine the error message.
  LogTailException(this.statusCode);

  /// The HTTP status code associated with this exception.
  final int statusCode;

  /// Returns a user-friendly error message based on the HTTP [statusCode].
  ///
  /// If the [statusCode] matches a known error,
  /// an appropriate message is returned.
  /// If no specific error is found, a generic error message is returned.
  /// If an error occurs while determining the message, it returns `null`.
  String? get message {
    try {
      switch (statusCode) {
        case 403:
          return 'Unauthorized.';
        case 406:
          return "Couldn't parse JSON content.";
        case 413:
          return 'Payload reached size limit.';
        default:
          return 'Something went wrong.';
      }
    } catch (e) {
      return null; // Return null if an error occurs while fetching the message.
    }
  }
}
