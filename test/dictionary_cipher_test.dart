import 'package:flutter_test/flutter_test.dart';
import 'package:learnenglishflutter/data/database/dictionary_cipher.dart';

void main() {
  group('DictionaryCipher Tests', () {
    test('Encodes plain English text to Caesar +17 offset', () {
      expect(DictionaryCipher.encode('AB'), 'RS');
      expect(DictionaryCipher.encode('HELLO'), 'YV]]`');
      expect(DictionaryCipher.encode('AARDVARK'), r'RRcUgRc\');
    });

    test('Decodes Caesar +17 offset text to plain English', () {
      expect(DictionaryCipher.decode('RS'), 'AB');
      expect(DictionaryCipher.decode('YV]]`'), 'HELLO');
      expect(DictionaryCipher.decode(r'RRcUgRc\'), 'AARDVARK');
    });

    test('Handles empty strings gracefully', () {
      expect(DictionaryCipher.encode(''), '');
      expect(DictionaryCipher.decode(''), '');
    });
  });
}
