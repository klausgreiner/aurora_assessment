import 'package:flutter_test/flutter_test.dart';
import 'package:aurora_assessment/core/error/failures.dart';

void main() {
  group('Failure', () {
    test('stores message correctly', () {
      const message = 'Test error message';
      const failure = NetworkFailure(message);
      
      expect(failure.message, message);
    });

    test('allows different messages', () {
      const message1 = 'First error';
      const message2 = 'Second error';
      const failure1 = NetworkFailure(message1);
      const failure2 = NetworkFailure(message2);
      
      expect(failure1.message, message1);
      expect(failure2.message, message2);
      expect(failure1.message, isNot(equals(failure2.message)));
    });
  });

  group('NetworkFailure', () {
    test('creates instance with message', () {
      const message = 'Network error occurred';
      const failure = NetworkFailure(message);
      
      expect(failure, isA<NetworkFailure>());
      expect(failure, isA<Failure>());
      expect(failure.message, message);
    });

    test('handles empty message', () {
      const failure = NetworkFailure('');
      
      expect(failure.message, isEmpty);
    });

    test('handles long error messages', () {
      final longMessage = 'A' * 1000;
      final failure = NetworkFailure(longMessage);
      
      expect(failure.message, longMessage);
      expect(failure.message.length, 1000);
    });

    test('creates multiple instances independently', () {
      const failure1 = NetworkFailure('Error 1');
      const failure2 = NetworkFailure('Error 2');
      const failure3 = NetworkFailure('Error 1');
      
      expect(failure1.message, 'Error 1');
      expect(failure2.message, 'Error 2');
      expect(failure3.message, 'Error 1');
      expect(failure1, isNot(same(failure2)));
      expect(failure1.message, equals(failure3.message));
    });
  });
}
