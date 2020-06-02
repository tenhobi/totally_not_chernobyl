import 'package:flutter_test/flutter_test.dart';
import 'package:totally_not_chernobyl/core/utils/random_string.dart';

void main() {
  group('randomString', () {
    test(
      'is random',
      () async {
        // arrange
        final tNumber = 5;
        // act
        final result1 = randomString(tNumber);
        final result2 = randomString(tNumber);
        // assert
        expect(result1 != result2, true);
      },
    );

    test(
      'with only 1 char as charTable is equal with another instance',
      () async {
        // arrange
        final tNumber = 5;
        final tCharTable = 'x';
        // act
        final result1 = randomString(tNumber, charTable: tCharTable);
        final result2 = randomString(tNumber, charTable: tCharTable);
        // assert
        expect(result1 == result2, true);
      },
    );
  });
}
