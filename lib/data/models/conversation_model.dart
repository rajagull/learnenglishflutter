class ConversationCategory {
  final int id;
  final String englishName;
  final String urduName;

  const ConversationCategory({
    required this.id,
    required this.englishName,
    required this.urduName,
  });

  factory ConversationCategory.fromMap(Map<String, dynamic> map) {
    return ConversationCategory(
      id: map['conversation_id'] as int? ?? 0,
      englishName: (map['conversation_name'] as String?)?.trim() ?? '',
      urduName: (map['conversation_urdu'] as String?)?.trim() ?? '',
    );
  }
}

class ConversationDetail {
  final int id;
  final int categoryId;
  final String english;
  final String urdu;
  final String roman;

  const ConversationDetail({
    required this.id,
    required this.categoryId,
    required this.english,
    required this.urdu,
    required this.roman,
  });

  factory ConversationDetail.fromMap(Map<String, dynamic> map) {
    return ConversationDetail(
      id: map['conversation_detail_id'] as int? ?? 0,
      categoryId: map['conversation_detail_id_foreign'] as int? ?? 0,
      english: (map['conversation_detail_english'] as String?)?.trim() ?? '',
      urdu: (map['conversation_detail_urdu'] as String?)?.trim() ?? '',
      roman: (map['conversation_detail_roman'] as String?)?.trim() ?? '',
    );
  }

  /// Extracts speaker name if formatted as "Speaker: Content"
  String get speaker {
    final colonIndex = english.indexOf(':');
    if (colonIndex > 0 && colonIndex < 30) {
      return english.substring(0, colonIndex).trim();
    }
    return '';
  }

  /// Extracts message dialogue content without speaker name
  String get dialogueText {
    final colonIndex = english.indexOf(':');
    if (colonIndex > 0 && colonIndex < 30) {
      return english.substring(colonIndex + 1).trim();
    }
    return english;
  }
}
