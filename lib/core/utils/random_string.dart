import 'dart:math';

const String _charTable =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz0123456789';

/// Generates a [stringLength] characters long [String]
/// based on characters from [charTable].
///
///     randomString(3); // 'aXa' or '31a' or 'XY5'...
///     randomString(3, charTable: 'a1'); // 'a1a' or 'aa1' or '11a'...
///
String randomString(int stringLength, {String charTable = _charTable}) {
  final random = Random.secure();
  final charList = List.generate(stringLength, (index) {
    return charTable[random.nextInt(charTable.length)];
  });

  return charList.join('');
}
