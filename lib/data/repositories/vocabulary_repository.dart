import '../database/database_helper.dart';
import '../models/vocabulary_model.dart';

class VocabularyRepository {
  final DatabaseHelper _dbHelper;

  VocabularyRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<VocabularyCategory>> getCategories() async {
    final db = await _dbHelper.vocabularyDb;
    final List<Map<String, dynamic>> maps = await db.query(
      'vocabulary',
      orderBy: 'vocabulary_id ASC',
    );
    return maps.map((m) => VocabularyCategory.fromMap(m)).toList();
  }

  Future<List<VocabularyItem>> getItems(int categoryId) async {
    final db = await _dbHelper.vocabularyDb;
    final List<Map<String, dynamic>> maps = await db.query(
      'vocabulary_example',
      where: 'vocabulary_id = ?',
      whereArgs: [categoryId],
      orderBy: 'vocablary_example_id ASC',
    );
    return maps.map((m) => VocabularyItem.fromMap(m)).toList();
  }

  Future<int> getCategoriesCount() async {
    final db = await _dbHelper.vocabularyDb;
    final res = await db.rawQuery('SELECT count(*) as count FROM vocabulary');
    return (res.first['count'] as int?) ?? 0;
  }

  Future<int> getTotalWordsCount() async {
    final db = await _dbHelper.vocabularyDb;
    final res = await db.rawQuery('SELECT count(*) as count FROM vocabulary_example');
    return (res.first['count'] as int?) ?? 0;
  }

  Future<List<VocabularyItem>> getRandomItems({int count = 5}) async {
    final db = await _dbHelper.vocabularyDb;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM vocabulary_example ORDER BY RANDOM() LIMIT ?',
      [count],
    );
    return maps.map((m) => VocabularyItem.fromMap(m)).toList();
  }
}
