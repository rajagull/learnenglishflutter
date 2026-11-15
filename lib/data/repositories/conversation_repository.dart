import '../database/database_helper.dart';
import '../models/conversation_model.dart';

class ConversationRepository {
  final DatabaseHelper _dbHelper;

  ConversationRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<ConversationCategory>> getCategories() async {
    final db = await _dbHelper.conversationDb;
    final List<Map<String, dynamic>> maps = await db.query(
      'converstion_category',
      orderBy: 'conversation_id ASC',
    );
    return maps.map((m) => ConversationCategory.fromMap(m)).toList();
  }

  Future<List<ConversationDetail>> getDetails(int categoryId) async {
    final db = await _dbHelper.conversationDb;
    final List<Map<String, dynamic>> maps = await db.query(
      'conversation_detail',
      where: 'conversation_detail_id_foreign = ?',
      whereArgs: [categoryId],
      orderBy: 'conversation_detail_id ASC',
    );
    return maps.map((m) => ConversationDetail.fromMap(m)).toList();
  }

  Future<int> getCategoriesCount() async {
    final db = await _dbHelper.conversationDb;
    final res = await db.rawQuery('SELECT count(*) as count FROM converstion_category');
    return (res.first['count'] as int?) ?? 0;
  }

  Future<int> getTotalDialoguesCount() async {
    final db = await _dbHelper.conversationDb;
    final res = await db.rawQuery('SELECT count(*) as count FROM conversation_detail');
    return (res.first['count'] as int?) ?? 0;
  }
}
