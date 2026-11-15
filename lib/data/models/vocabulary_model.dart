class VocabularyCategory {
  final int id;
  final String englishName;
  final String urduName;

  const VocabularyCategory({
    required this.id,
    required this.englishName,
    required this.urduName,
  });

  factory VocabularyCategory.fromMap(Map<String, dynamic> map) {
    return VocabularyCategory(
      id: map['vocabulary_id'] as int? ?? 0,
      englishName: (map['vocabulary_english_name'] as String?)?.trim() ?? '',
      urduName: (map['vocabulary_urdu_name'] as String?)?.trim() ?? '',
    );
  }
}

class VocabularyItem {
  final int id;
  final int categoryId;
  final String english;
  final String urdu;
  final String roman;

  const VocabularyItem({
    required this.id,
    required this.categoryId,
    required this.english,
    required this.urdu,
    required this.roman,
  });

  factory VocabularyItem.fromMap(Map<String, dynamic> map) {
    return VocabularyItem(
      id: map['vocablary_example_id'] as int? ?? 0,
      categoryId: map['vocabulary_id'] as int? ?? 0,
      english: (map['vocabulary_example_english'] as String?)?.trim() ?? '',
      urdu: (map['vocabulary_example_urdu'] as String?)?.trim() ?? '',
      roman: (map['vocabulary_example_roman'] as String?)?.trim() ?? '',
    );
  }
}
