class IdiomItem {
  final int id;
  final String english;
  final String urdu;

  const IdiomItem({
    required this.id,
    required this.english,
    required this.urdu,
  });

  factory IdiomItem.fromMap(Map<String, dynamic> map) {
    return IdiomItem(
      id: map['idiom_id'] as int? ?? 0,
      english: (map['idiom_english'] as String?)?.trim() ?? '',
      urdu: (map['idiom_urdu'] as String?)?.trim() ?? '',
    );
  }

  /// Title-cased presentation string
  String get displayEnglish {
    if (english.isEmpty) return '';
    return english.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
