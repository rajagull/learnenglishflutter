class TenseMain {
  final int id;
  final String name;

  const TenseMain({
    required this.id,
    required this.name,
  });

  factory TenseMain.fromMap(Map<String, dynamic> map) {
    return TenseMain(
      id: map['tense_id'] as int? ?? 0,
      name: (map['tense_name'] as String?)?.trim() ?? '',
    );
  }
}

class TenseCategory {
  final int id;
  final int tenseId;
  final String englishName;
  final String urduName;
  final String definitionEnglish;
  final String definitionUrdu;
  final String positiveRuleEnglish;
  final String positiveRuleUrdu;
  final String negativeRuleEnglish;
  final String negativeRuleUrdu;
  final String interrogativeRuleEnglish;
  final String interrogativeRuleUrdu;

  const TenseCategory({
    required this.id,
    required this.tenseId,
    required this.englishName,
    required this.urduName,
    required this.definitionEnglish,
    required this.definitionUrdu,
    required this.positiveRuleEnglish,
    required this.positiveRuleUrdu,
    required this.negativeRuleEnglish,
    required this.negativeRuleUrdu,
    required this.interrogativeRuleEnglish,
    required this.interrogativeRuleUrdu,
  });

  factory TenseCategory.fromMap(Map<String, dynamic> map) {
    return TenseCategory(
      id: map['tense_category_id'] as int? ?? 0,
      tenseId: map['tense_id'] as int? ?? 0,
      englishName: (map['tense_category_english_name'] as String?)?.trim() ?? '',
      urduName: (map['tense_category_urdu_name'] as String?)?.trim() ?? '',
      definitionEnglish: (map['tense_definition_english'] as String?)?.trim() ?? '',
      definitionUrdu: (map['tense_definition_urdu'] as String?)?.trim() ?? '',
      positiveRuleEnglish: (map['tense_positve_rule_english'] as String?)?.trim() ?? '',
      positiveRuleUrdu: (map['tense_positive_rule_urdu'] as String?)?.trim() ?? '',
      negativeRuleEnglish: (map['tense_negative_rule_english'] as String?)?.trim() ?? '',
      negativeRuleUrdu: (map['tense_negative_rule_urdu'] as String?)?.trim() ?? '',
      interrogativeRuleEnglish: (map['tense_interrogative_rule_english'] as String?)?.trim() ?? '',
      interrogativeRuleUrdu: (map['tense_interrogative_rule_urdu'] as String?)?.trim() ?? '',
    );
  }
}

class TenseExample {
  final int id;
  final int categoryId;
  final String positiveEnglish;
  final String positiveUrdu;
  final String negativeEnglish;
  final String negativeUrdu;
  final String interrogativeEnglish;
  final String interrogativeUrdu;

  const TenseExample({
    required this.id,
    required this.categoryId,
    required this.positiveEnglish,
    required this.positiveUrdu,
    required this.negativeEnglish,
    required this.negativeUrdu,
    required this.interrogativeEnglish,
    required this.interrogativeUrdu,
  });

  factory TenseExample.fromMap(Map<String, dynamic> map) {
    return TenseExample(
      id: map['tense_example_id'] as int? ?? 0,
      categoryId: map['tense_category_id'] as int? ?? 0,
      positiveEnglish: (map['tense_positive_english'] as String?)?.trim() ?? '',
      positiveUrdu: (map['tense_positive_urdu'] as String?)?.trim() ?? '',
      negativeEnglish: (map['tense_negative_english'] as String?)?.trim() ?? '',
      negativeUrdu: (map['tense_negative_urdu'] as String?)?.trim() ?? '',
      interrogativeEnglish: (map['tense_interrogative_english'] as String?)?.trim() ?? '',
      interrogativeUrdu: (map['tense_interrogative_urdu'] as String?)?.trim() ?? '',
    );
  }
}
