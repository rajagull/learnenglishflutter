class SingularPluralItem {
  final int id;
  final String singular;
  final String plural;

  const SingularPluralItem({
    required this.id,
    required this.singular,
    required this.plural,
  });

  factory SingularPluralItem.fromMap(Map<String, dynamic> map) {
    return SingularPluralItem(
      id: map['word_id'] as int? ?? 0,
      singular: (map['word_singular'] as String?)?.trim() ?? '',
      plural: (map['word_plural'] as String?)?.trim() ?? '',
    );
  }
}
