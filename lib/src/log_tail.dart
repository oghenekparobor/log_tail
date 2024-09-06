import 'package:log_tail/src/client/log_tail.client.dart';
import 'package:log_tail/src/log_tail.type.dart';
import 'package:logger/logger.dart';

/// {@template log_tail}
/// A utility class to send logs to Bette rstack's LogTail 
/// service and optionally
/// log to the console. This class provides methods to log single or multiple
/// events, either to the server, the console, or both.
/// {@endtemplate}
class LogTail {
  /// {@macro log_tail}
  ///
  /// Creates an instance of [LogTail] with the given [_sourceToken].
  ///
  /// The [_sourceToken] is used for authenticating requests
  /// to the LogTail server.
  LogTail(this._sourceToken, {LogTailClient? client}) {
    _client = client ?? LogTailClient(_sourceToken);
  }

  /// The source token used for authenticating with the LogTail server.
  final String _sourceToken;

  /// The client used to send log events to the LogTail server.
  late final LogTailClient _client;

  /// Logs a single [event] to the console and/or the LogTail server.
  ///
  /// The [event] parameter is the log message to be sent. The optional [extra]
  /// parameter can be used to include additional data with the log message.
  /// The [type] parameter determines whether the event should be logged to the
  /// server, the console, or both. Defaults to [LogTailType.both].
  ///
  /// Returns a [Future] that resolves to a [String] indicating
  /// the result of the log
  /// operation, or `null` if only logging to the console.
  Future<String?> logEvent(
    String event, {
    Map<String, dynamic>? extra,
    LogTailType type = LogTailType.serverOnly,
  }) async {
    _logToConsole(event, type); // Log to console if needed

    if (type != LogTailType.consoleOnly) {
      return _client.sendSingleEvent(event: event, extra: extra);
    }
    return null;
  }

  /// Logs multiple [events] to the console and/or the LogTail server.
  ///
  /// The [events] parameter is a list of log messages to be sent.
  /// The [type] parameter determines whether the events should be logged to the
  /// server, the console, or both. Defaults to [LogTailType.both].
  ///
  /// Returns a [Future] that resolves to a [String] indicating
  /// the result of the log
  /// operation, or `null` if only logging to the console.
  Future<String?> logEvents(
    List<String> events, {
    LogTailType type = LogTailType.serverOnly,
  }) async {
    _logToConsole(events, type); // Log to console if needed

    if (type != LogTailType.consoleOnly) {
      return _client.sendMultipleEvents(events);
    }
    return null;
  }

  /// Logs a [message] to the console if the [type] is [LogTailType.both] or
  /// [LogTailType.consoleOnly].
  ///
  /// This method uses the `Logger` package to output the
  /// message to the console.
  /// It is used internally by [logEvent] and [logEvents] methods.
  void _logToConsole(dynamic message, LogTailType type) {
    if (type == LogTailType.both || type == LogTailType.consoleOnly) {
      Logger().d(message);
    }
  }
}
