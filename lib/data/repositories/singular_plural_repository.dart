import '../database/database_helper.dart';
import '../models/singular_plural_model.dart';

class SingularPluralRepository {
  final DatabaseHelper _dbHelper;

  SingularPluralRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<SingularPluralItem>> getAll({String? query}) async {
    final db = await _dbHelper.singularPluralDb;
    final List<Map<String, dynamic>> maps;

    if (query != null && query.trim().isNotEmpty) {
      final sanitized = '%${query.trim().toLowerCase()}%';
      maps = await db.query(
        'singular_plural',
        where: 'word_singular LIKE ? OR word_plural LIKE ?',
        whereArgs: [sanitized, sanitized],
        orderBy: 'word_id ASC',
      );
    } else {
      maps = await db.query(
        'singular_plural',
        orderBy: 'word_id ASC',
      );
    }
    return maps.map((m) => SingularPluralItem.fromMap(m)).toList();
  }

  Future<int> getTotalCount() async {
    final db = await _dbHelper.singularPluralDb;
    final res = await db.rawQuery('SELECT count(*) as count FROM singular_plural');
    return (res.first['count'] as int?) ?? 0;
  }

  Future<List<SingularPluralItem>> getRandomPairs({int count = 4}) async {
    final db = await _dbHelper.singularPluralDb;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM singular_plural ORDER BY RANDOM() LIMIT ?',
      [count],
    );
    return maps.map((m) => SingularPluralItem.fromMap(m)).toList();
  }
}
