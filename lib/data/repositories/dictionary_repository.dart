import '../database/database_helper.dart';
import '../database/dictionary_cipher.dart';
import '../models/dictionary_model.dart';

class DictionaryRepository {
  final DatabaseHelper _dbHelper;

  DictionaryRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<DictionaryWord>> searchWords(String rawQuery, {int limit = 30}) async {
    final query = rawQuery.trim();
    if (query.isEmpty) {
      return getRecentOrPopularWords(limit: limit);
    }

    final db = await _dbHelper.dictionaryDb;

    // Check if query is English letters
    final isAscii = query.codeUnits.every((c) => c < 128);

    List<Map<String, dynamic>> wordRows = [];

    if (isAscii) {
      final encPrefix = DictionaryCipher.encode(query);
      // Try prefix match first
      wordRows = await db.query(
        'words',
        where: 'word LIKE ?',
        whereArgs: ['$encPrefix%'],
        limit: limit,
        orderBy: 'id ASC',
      );

      // If fewer than limit, also search meaning table for Roman Urdu match
      if (wordRows.length < limit) {
        final remaining = limit - wordRows.length;
        final existingIds = wordRows.map((r) => r['id'] as int).toList();
        final idPlaceholder = existingIds.isNotEmpty
            ? 'AND w.id NOT IN (${existingIds.join(",")})'
            : '';
        final romanRows = await db.rawQuery('''
          SELECT DISTINCT w.id, w.word, w.definition, w.synonyms, w.antonyms, w.near_by_words
          FROM meaning m
          JOIN words w ON m.id_word = w.id
          WHERE m.roman LIKE ? $idPlaceholder
          LIMIT ?
        ''', ['%$query%', remaining]);
        wordRows.addAll(romanRows);
      }
    } else {
      // Urdu text search in meaning table
      final meaningRows = await db.rawQuery('''
        SELECT DISTINCT w.id, w.word, w.definition, w.synonyms, w.antonyms, w.near_by_words
        FROM meaning m
        JOIN words w ON m.id_word = w.id
        WHERE m.mean LIKE ?
        LIMIT ?
      ''', ['%$query%', limit]);
      wordRows = List<Map<String, dynamic>>.from(meaningRows);
    }

    if (wordRows.isEmpty) return [];

    final wordIds = wordRows.map((r) => r['id'] as int).toList();
    final meaningsMap = await _fetchMeaningsForWordIds(wordIds);

    return wordRows.map((row) {
      final id = row['id'] as int;
      final meanings = meaningsMap[id] ?? [];
      return DictionaryWord.fromMap(row, meanings: meanings);
    }).toList();
  }

  Future<List<DictionaryWord>> getRecentOrPopularWords({int limit = 20}) async {
    final db = await _dbHelper.dictionaryDb;
    // Select a pleasant starter list of words (skip dummy ids 1-3)
    final wordRows = await db.query(
      'words',
      where: 'id >= ?',
      whereArgs: [4],
      limit: limit,
      orderBy: 'id ASC',
    );

    final wordIds = wordRows.map((r) => r['id'] as int).toList();
    final meaningsMap = await _fetchMeaningsForWordIds(wordIds);

    return wordRows.map((row) {
      final id = row['id'] as int;
      final meanings = meaningsMap[id] ?? [];
      return DictionaryWord.fromMap(row, meanings: meanings);
    }).toList();
  }

  Future<Map<int, List<DictionaryMeaning>>> _fetchMeaningsForWordIds(List<int> wordIds) async {
    if (wordIds.isEmpty) return {};
    final db = await _dbHelper.dictionaryDb;
    final placeholders = List.filled(wordIds.length, '?').join(',');
    final meaningRows = await db.query(
      'meaning',
      where: 'id_word IN ($placeholders)',
      whereArgs: wordIds,
      orderBy: 'id ASC',
    );

    final Map<int, List<DictionaryMeaning>> result = {};
    for (final row in meaningRows) {
      final m = DictionaryMeaning.fromMap(row);
      result.putIfAbsent(m.wordId, () => []).add(m);
    }
    return result;
  }

  Future<DictionaryWord?> getWordDetails(int wordId) async {
    final db = await _dbHelper.dictionaryDb;
    final rows = await db.query(
      'words',
      where: 'id = ?',
      whereArgs: [wordId],
      limit: 1,
    );
    if (rows.isEmpty) return null;

    final meaningsMap = await _fetchMeaningsForWordIds([wordId]);
    return DictionaryWord.fromMap(rows.first, meanings: meaningsMap[wordId] ?? []);
  }

  Future<DictionaryWord?> getRandomWord() async {
    final db = await _dbHelper.dictionaryDb;
    // Pick random from id between 10 and 50000
    final rows = await db.rawQuery(
      'SELECT * FROM words WHERE id > 4 ORDER BY RANDOM() LIMIT 1',
    );
    if (rows.isEmpty) return null;
    final id = rows.first['id'] as int;
    final meaningsMap = await _fetchMeaningsForWordIds([id]);
    return DictionaryWord.fromMap(rows.first, meanings: meaningsMap[id] ?? []);
  }

  Future<int> getTotalCount() async {
    final db = await _dbHelper.dictionaryDb;
    final res = await db.rawQuery('SELECT count(*) as count FROM words');
    return (res.first['count'] as int?) ?? 0;
  }
}
