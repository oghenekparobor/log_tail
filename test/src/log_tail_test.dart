// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:log_tail/log_tail.dart';
import 'package:log_tail/src/client/log_tail.client.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

class MockLogTailClient extends Mock implements LogTailClient {}

class MockLogger extends Mock implements Logger {}

void main() {
  late MockLogTailClient client;
  const sourceToken = '12345_12323';
  late LogTail logTail;
  late MockLogger logger;

  setUp(() {
    client = MockLogTailClient();
    logger = MockLogger();

    logTail = LogTail(sourceToken, client: client);
  });

  group('LogTail Event', () {
    test('log single event', () async {
      // Arrange
      const response = 'The event(s) were successfully logged';

      when(() => logger.d('event')).thenReturn(null);

      when(() => client.sendSingleEvent(event: 'event')).thenAnswer(
        (_) async => response,
      );

      // Act
      final resutl = await logTail.logEvent('event');

      // Assert
      expect(resutl, response);
    });

    test('log multiple event', () async {
      // Arrange
      const response = 'The event(s) were successfully logged';

      when(() => client.sendMultipleEvents(['events'])).thenAnswer(
        (_) async => response,
      );

      // Act
      final resutl = await logTail.logEvents(['events']);

      // Assert
      expect(resutl, response);
    });
  });
}
