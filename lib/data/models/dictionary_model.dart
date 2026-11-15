import '../database/dictionary_cipher.dart';

class DictionaryMeaning {
  final int id;
  final int wordId;
  final String mean;
  final String roman;

  const DictionaryMeaning({
    required this.id,
    required this.wordId,
    required this.mean,
    required this.roman,
  });

  factory DictionaryMeaning.fromMap(Map<String, dynamic> map) {
    return DictionaryMeaning(
      id: map['id'] as int? ?? 0,
      wordId: map['id_word'] as int? ?? 0,
      mean: (map['mean'] as String?)?.trim() ?? '',
      roman: (map['roman'] as String?)?.trim() ?? '',
    );
  }
}

class DictionaryWord {
  final int id;
  final String word;
  final String definition;
  final String synonyms;
  final String antonyms;
  final String nearByWords;
  final List<DictionaryMeaning> meanings;

  const DictionaryWord({
    required this.id,
    required this.word,
    required this.definition,
    required this.synonyms,
    required this.antonyms,
    required this.nearByWords,
    this.meanings = const [],
  });

  factory DictionaryWord.fromMap(
    Map<String, dynamic> map, {
    List<DictionaryMeaning> meanings = const [],
  }) {
    final rawWord = (map['word'] as String?) ?? '';
    final decodedWord = DictionaryCipher.decode(rawWord);

    return DictionaryWord(
      id: map['id'] as int? ?? 0,
      word: decodedWord,
      definition: (map['definition'] as String?)?.trim() ?? '',
      synonyms: (map['synonyms'] as String?)?.trim() ?? '',
      antonyms: (map['antonyms'] as String?)?.trim() ?? '',
      nearByWords: (map['near_by_words'] as String?)?.trim() ?? '',
      meanings: meanings,
    );
  }

  DictionaryWord copyWith({List<DictionaryMeaning>? meanings}) {
    return DictionaryWord(
      id: id,
      word: word,
      definition: definition,
      synonyms: synonyms,
      antonyms: antonyms,
      nearByWords: nearByWords,
      meanings: meanings ?? this.meanings,
    );
  }
}
