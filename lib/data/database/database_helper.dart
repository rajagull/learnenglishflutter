import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? _conversationDb;
  Database? _vocabularyDb;
  Database? _tensesDb;
  Database? _idiomsDb;
  Database? _singularPluralDb;
  Database? _dictionaryDb;

  bool _isFfiInitialized = false;

  void _ensureFfiInitialized() {
    if (_isFfiInitialized) return;
    if (!kIsWeb && (Platform.isMacOS || Platform.isLinux || Platform.isWindows)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    _isFfiInitialized = true;
  }

  Future<String> _getAppDatabasePath(String dbName) async {
    _ensureFfiInitialized();
    String basePath;
    if (!kIsWeb && Platform.isAndroid) {
      basePath = await getDatabasesPath();
    } else {
      final docDir = await getApplicationDocumentsDirectory();
      basePath = docDir.path;
    }
    final dbDir = Directory(basePath);
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }
    return p.join(basePath, dbName);
  }

  Future<String> copyAssetDbIfNeeded(String dbFileName) async {
    final dbPath = await _getAppDatabasePath(dbFileName);
    final file = File(dbPath);

    // If file does not exist or is empty, copy from asset bundle
    if (!await file.exists() || (await file.length()) == 0) {
      debugPrint('[DatabaseHelper] Copying $dbFileName from assets to $dbPath...');
      final data = await rootBundle.load('assets/db/$dbFileName');
      final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await file.writeAsBytes(bytes, flush: true);
      debugPrint('[DatabaseHelper] Copied $dbFileName (${bytes.length} bytes)');
    }
    return dbPath;
  }

  Future<Database> get conversationDb async {
    if (_conversationDb != null && _conversationDb!.isOpen) {
      return _conversationDb!;
    }
    final path = await copyAssetDbIfNeeded('conversation.db');
    _conversationDb = await openDatabase(path, readOnly: true);
    return _conversationDb!;
  }

  Future<Database> get vocabularyDb async {
    if (_vocabularyDb != null && _vocabularyDb!.isOpen) {
      return _vocabularyDb!;
    }
    final path = await copyAssetDbIfNeeded('vocabulary.db');
    _vocabularyDb = await openDatabase(path, readOnly: true);
    return _vocabularyDb!;
  }

  Future<Database> get tensesDb async {
    if (_tensesDb != null && _tensesDb!.isOpen) {
      return _tensesDb!;
    }
    final path = await copyAssetDbIfNeeded('tenses.db');
    _tensesDb = await openDatabase(path, readOnly: true);
    return _tensesDb!;
  }

  Future<Database> get idiomsDb async {
    if (_idiomsDb != null && _idiomsDb!.isOpen) {
      return _idiomsDb!;
    }
    final path = await copyAssetDbIfNeeded('idioms.db');
    _idiomsDb = await openDatabase(path, readOnly: true);
    return _idiomsDb!;
  }

  Future<Database> get singularPluralDb async {
    if (_singularPluralDb != null && _singularPluralDb!.isOpen) {
      return _singularPluralDb!;
    }
    final path = await copyAssetDbIfNeeded('singular_plural.db');
    _singularPluralDb = await openDatabase(path, readOnly: true);
    return _singularPluralDb!;
  }

  Future<Database> get dictionaryDb async {
    if (_dictionaryDb != null && _dictionaryDb!.isOpen) {
      return _dictionaryDb!;
    }
    final path = await copyAssetDbIfNeeded('dictionary.db');
    // Open in read-write initially to ensure indexes, or readOnly
    _dictionaryDb = await openDatabase(path);
    // Ensure indices exist for blazing fast search queries
    try {
      await _dictionaryDb!.execute('CREATE INDEX IF NOT EXISTS idx_words_word ON words(word);');
      await _dictionaryDb!.execute('CREATE INDEX IF NOT EXISTS idx_meaning_id_word ON meaning(id_word);');
    } catch (e) {
      debugPrint('[DatabaseHelper] Index creation note: $e');
    }
    return _dictionaryDb!;
  }

  /// Pre-initializes core databases for instant dashboard responsiveness
  Future<void> initCoreDatabases() async {
    _ensureFfiInitialized();
    await Future.wait([
      conversationDb,
      vocabularyDb,
      tensesDb,
      idiomsDb,
      singularPluralDb,
    ]);
  }

  /// Closes all open databases
  Future<void> closeAll() async {
    await _conversationDb?.close();
    await _vocabularyDb?.close();
    await _tensesDb?.close();
    await _idiomsDb?.close();
    await _singularPluralDb?.close();
    await _dictionaryDb?.close();
    _conversationDb = null;
    _vocabularyDb = null;
    _tensesDb = null;
    _idiomsDb = null;
    _singularPluralDb = null;
    _dictionaryDb = null;
  }
}
