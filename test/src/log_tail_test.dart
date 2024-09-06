// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:log_tail/log_tail.dart';

void main() {
  group('LogTail', () {
    test('can be instantiated', () {
      expect(LogTail(), isNotNull);
    });
  });
}
