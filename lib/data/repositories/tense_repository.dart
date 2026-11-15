import '../database/database_helper.dart';
import '../models/tense_model.dart';

class TenseRepository {
  final DatabaseHelper _dbHelper;

  TenseRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<TenseMain>> getMainTenses() async {
    final db = await _dbHelper.tensesDb;
    final List<Map<String, dynamic>> maps = await db.query(
      'tenses',
      orderBy: 'tense_id ASC',
    );
    return maps.map((m) => TenseMain.fromMap(m)).toList();
  }

  Future<List<TenseCategory>> getCategories({int? tenseId}) async {
    final db = await _dbHelper.tensesDb;
    final List<Map<String, dynamic>> maps;
    if (tenseId != null) {
      maps = await db.query(
        'tenses_categories',
        where: 'tense_id = ?',
        whereArgs: [tenseId],
        orderBy: 'tense_category_id ASC',
      );
    } else {
      maps = await db.query(
        'tenses_categories',
        orderBy: 'tense_category_id ASC',
      );
    }
    return maps.map((m) => TenseCategory.fromMap(m)).toList();
  }

  Future<List<TenseExample>> getExamples(int categoryId) async {
    final db = await _dbHelper.tensesDb;
    final List<Map<String, dynamic>> maps = await db.query(
      'tense_example',
      where: 'tense_category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'tense_example_id ASC',
    );
    return maps.map((m) => TenseExample.fromMap(m)).toList();
  }

  Future<int> getTotalTensesCount() async {
    final db = await _dbHelper.tensesDb;
    final res = await db.rawQuery('SELECT count(*) as count FROM tenses_categories');
    return (res.first['count'] as int?) ?? 0;
  }
}
