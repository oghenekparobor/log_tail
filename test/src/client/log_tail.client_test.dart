import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:log_tail/src/client/log_tail.client.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockResponse<T> extends Mock implements Response<T> {}

void main() {
  late MockDio mockDio;
  late LogTailClient logTailClient;
  const baseUrl = 'https://base-url.com';
  const sourceToken = 'testToken';

  setUp(() {
    mockDio = MockDio()
      ..options = BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Authorization': 'Bearer $sourceToken',
        },
      );

    logTailClient = LogTailClient(sourceToken, dio: mockDio);
  });

  group('LogTailClient sending single event test', () {
    testWidgets(
      'sendSingleEvent should return success message on 202 status code',
      (tester) async {
        // Arrange
        final mockResponse = MockResponse<Map<String, dynamic>>();

        when(() => mockResponse.statusCode).thenReturn(202);
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await logTailClient.sendSingleEvent(
          event: 'Test Event',
          extra: {},
        );

        // Assert
        expect(result, 'The event(s) were successfully logged');
      },
    );

    test('sendSingleEvent should return error message on non-202 status code',
        () async {
      // Arrange
      final mockResponse = MockResponse<Map<String, dynamic>>();
      when(() => mockResponse.statusCode).thenReturn(403);
      when(
        () => mockDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await logTailClient.sendSingleEvent(
        event: 'Test Event',
        extra: {},
      );

      // Assert
      expect(result, 'Unauthorized.');
    });

    test('sendSingleEvent should handle DioError', () async {
      // Arrange
      when(
        () => mockDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: 'Network Error',
        ),
      );

      // Act
      final result = await logTailClient.sendSingleEvent(
        event: 'Test Event',
        extra: {},
      );

      // Assert
      expect(result, contains('An error occurred:'));
    });
  });

  group('LogTailClient sending single event test', () {
    test('sendMultipleEvents should return success message on 202 status code',
        () async {
      // Arrange
      final mockResponse = MockResponse<Map<String, dynamic>>();
      when(() => mockResponse.statusCode).thenReturn(202);
      when(
        () => mockDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await logTailClient.sendMultipleEvents(
        ['Event 1', 'Event 2'],
      );

      // Assert
      expect(result, 'The event(s) were successfully logged');
    });

    test(
        'sendMultipleEvents should return error message on non-202 status code',
        () async {
      // Arrange
      final mockResponse = MockResponse<Map<String, dynamic>>();
      when(() => mockResponse.statusCode).thenReturn(413);
      when(
        () => mockDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await logTailClient.sendMultipleEvents(
        ['Event 1', 'Event 2'],
      );

      // Assert
      expect(result, 'Payload reached size limit.');
    });
  });
}
