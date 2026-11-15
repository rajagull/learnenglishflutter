/// Cipher utility for encoding and decoding dictionary words.
/// In the dictionary.db, English words are shifted by +17 characters.
class DictionaryCipher {
  static const int shift = 17;

  /// Decodes a stored word from dictionary database (e.g. 'RS' -> 'AB')
  static String decode(String encoded) {
    if (encoded.isEmpty) return '';
    final buffer = StringBuffer();
    for (int i = 0; i < encoded.length; i++) {
      final code = encoded.codeUnitAt(i);
      buffer.writeCharCode(code - shift);
    }
    return buffer.toString();
  }

  /// Encodes a search query word (e.g. 'AB' -> 'RS') to query the dictionary database
  static String encode(String raw) {
    if (raw.isEmpty) return '';
    final upper = raw.toUpperCase();
    final buffer = StringBuffer();
    for (int i = 0; i < upper.length; i++) {
      final code = upper.codeUnitAt(i);
      buffer.writeCharCode(code + shift);
    }
    return buffer.toString();
  }
}
