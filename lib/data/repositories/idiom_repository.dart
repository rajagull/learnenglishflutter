import '../database/database_helper.dart';
import '../models/idiom_model.dart';

class IdiomRepository {
  final DatabaseHelper _dbHelper;

  IdiomRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<IdiomItem>> getIdioms({
    String? query,
    int limit = 50,
    int offset = 0,
  }) async {
    final db = await _dbHelper.idiomsDb;
    final List<Map<String, dynamic>> maps;

    if (query != null && query.trim().isNotEmpty) {
      final sanitized = '%${query.trim()}%';
      maps = await db.query(
        'idioms',
        where: 'idiom_english LIKE ? OR idiom_urdu LIKE ?',
        whereArgs: [sanitized, sanitized],
        limit: limit,
        offset: offset,
        orderBy: 'idiom_id ASC',
      );
    } else {
      maps = await db.query(
        'idioms',
        limit: limit,
        offset: offset,
        orderBy: 'idiom_id ASC',
      );
    }
    return maps.map((m) => IdiomItem.fromMap(m)).toList();
  }

  Future<int> getTotalCount() async {
    final db = await _dbHelper.idiomsDb;
    final res = await db.rawQuery('SELECT count(*) as count FROM idioms');
    return (res.first['count'] as int?) ?? 0;
  }

  Future<IdiomItem?> getRandomIdiom() async {
    final db = await _dbHelper.idiomsDb;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM idioms ORDER BY RANDOM() LIMIT 1',
    );
    if (maps.isEmpty) return null;
    return IdiomItem.fromMap(maps.first);
  }

  Future<List<IdiomItem>> getRandomIdioms({int count = 4}) async {
    final db = await _dbHelper.idiomsDb;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM idioms ORDER BY RANDOM() LIMIT ?',
      [count],
    );
    return maps.map((m) => IdiomItem.fromMap(m)).toList();
  }
}
