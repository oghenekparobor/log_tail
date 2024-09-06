import 'package:dio/dio.dart';
import 'package:log_tail/src/exception/tail.exception.dart';

/// A client class responsible for sending
/// log events to Betterstack's LogTail service.
class LogTailClient {
  /// Creates an instance of [LogTailClient] with the provided [sourceToken].
  ///
  /// The [sourceToken] is used for authenticating
  /// requests to the LogTail server.
  /// Initializes the Dio HTTP client with necessary configurations.
  LogTailClient(this.sourceToken) {
    dio = Dio(
      BaseOptions(
        baseUrl: kBaseUrl,
        persistentConnection: true,
        preserveHeaderCase: true,
        headers: {
          'Authorization': 'Bearer $sourceToken',
        },
      ),
    );
  }

  /// Base URL for the LogTail service API.
  static const kBaseUrl = 'https://in.logs.betterstack.com';

  /// Dio instance used to handle HTTP requests to the LogTail server.
  late final Dio dio;

  /// Token used for authenticating with the LogTail server.
  final String sourceToken;

  /// Sends a single log [event] to the LogTail server.
  ///
  /// Optionally, an [extra] map can be included to
  /// provide additional data with the log event.
  /// Returns a [Future] that resolves to a [String]
  /// indicating the result of the log operation.
  Future<String?> sendSingleEvent({
    required String event,
    Map<String, dynamic>? extra,
  }) async {
    return _sendRequest(data: {'message': event, ...?extra});
  }

  /// Sends multiple log [events] to the LogTail server.
  ///
  /// The [events] parameter is a list of log messages to be sent.
  /// Returns a [Future] that resolves to a [String]
  /// indicating the result of the log operation.
  Future<String?> sendMultipleEvents(List<String> events) async {
    final messages = events.map((event) => {'message': event}).toList();

    return _sendRequest(data: messages);
  }

  /// Internal method that sends an HTTP POST request
  /// with the provided [data] to the LogTail server.
  ///
  /// Handles the response and returns a [Future]
  /// that resolves to a [String] indicating the result of the operation.
  /// If the response status code is not 200,
  /// it calls [_handleError] to handle errors.
  Future<String?> _sendRequest({required dynamic data}) async {
    try {
      final response = await dio.post<Map<String, dynamic>>('', data: data);

      if (response.statusCode == 200) {
        return 'The event(s) were successfully logged';
      } else {
        return _handleError(response);
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  /// Handles errors that occur during the HTTP
  /// request by creating a [LogTailException].
  ///
  /// Takes the [response] parameter,
  /// which is the HTTP response received from the server,
  /// and returns the error message from the [LogTailException].
  String? _handleError(Response<dynamic> response) {
    return LogTailException(response.statusCode ?? 400).message;
  }
}
