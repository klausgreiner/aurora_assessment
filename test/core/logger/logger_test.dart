import 'package:flutter_test/flutter_test.dart';
import 'package:aurora_assessment/core/logger/logger.dart';

void main() {
  group('AppLogger', () {
    late AppLogger logger;

    setUp(() {
      logger = AppLogger();
    });

    test('debug method executes without error', () {
      expect(() => logger.debug('Test debug message'), returnsNormally);
    });

    test('info method executes without error', () {
      expect(() => logger.info('Test info message'), returnsNormally);
    });

    test('warning method executes without error', () {
      expect(() => logger.warning('Test warning message'), returnsNormally);
    });

    test('error method executes without error', () {
      expect(() => logger.error('Test error message'), returnsNormally);
    });

    test('debug handles error parameter', () {
      expect(
        () => logger.debug('Test message', 'Error object'),
        returnsNormally,
      );
    });

    test('info handles error parameter', () {
      expect(
        () => logger.info('Test message', 'Error object'),
        returnsNormally,
      );
    });

    test('warning handles error parameter', () {
      expect(
        () => logger.warning('Test message', 'Error object'),
        returnsNormally,
      );
    });

    test('error handles error parameter', () {
      expect(
        () => logger.error('Test message', 'Error object'),
        returnsNormally,
      );
    });

    test('debug handles stackTrace parameter', () {
      final stackTrace = StackTrace.current;
      expect(
        () => logger.debug('Test message', null, stackTrace),
        returnsNormally,
      );
    });

    test('info handles stackTrace parameter', () {
      final stackTrace = StackTrace.current;
      expect(
        () => logger.info('Test message', null, stackTrace),
        returnsNormally,
      );
    });

    test('warning handles stackTrace parameter', () {
      final stackTrace = StackTrace.current;
      expect(
        () => logger.warning('Test message', null, stackTrace),
        returnsNormally,
      );
    });

    test('error handles stackTrace parameter', () {
      final stackTrace = StackTrace.current;
      expect(
        () => logger.error('Test message', null, stackTrace),
        returnsNormally,
      );
    });

    test('debug handles both error and stackTrace', () {
      final stackTrace = StackTrace.current;
      expect(
        () => logger.debug('Test message', 'Error object', stackTrace),
        returnsNormally,
      );
    });

    test('info handles both error and stackTrace', () {
      final stackTrace = StackTrace.current;
      expect(
        () => logger.info('Test message', 'Error object', stackTrace),
        returnsNormally,
      );
    });

    test('warning handles both error and stackTrace', () {
      final stackTrace = StackTrace.current;
      expect(
        () => logger.warning('Test message', 'Error object', stackTrace),
        returnsNormally,
      );
    });

    test('error handles both error and stackTrace', () {
      final stackTrace = StackTrace.current;
      expect(
        () => logger.error('Test message', 'Error object', stackTrace),
        returnsNormally,
      );
    });

    test('handles empty message', () {
      expect(() => logger.debug(''), returnsNormally);
      expect(() => logger.info(''), returnsNormally);
      expect(() => logger.warning(''), returnsNormally);
      expect(() => logger.error(''), returnsNormally);
    });

    test('handles Exception objects as error', () {
      final exception = Exception('Test exception');
      expect(
        () => logger.error('Test message', exception),
        returnsNormally,
      );
    });

    test('handles multiple log calls', () {
      expect(() {
        logger.debug('Debug 1');
        logger.info('Info 1');
        logger.warning('Warning 1');
        logger.error('Error 1');
        logger.debug('Debug 2');
        logger.info('Info 2');
      }, returnsNormally);
    });
  });
}
