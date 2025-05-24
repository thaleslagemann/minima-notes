import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static final CacheService _cacheService = CacheService._();

  static CacheService get instance => _cacheService;

  CacheService._() {
    _init();
  }

  late Database _db;
  // ignore: unused_field
  late SharedPreferences _prefs;

  Future<void> _init() async {
    _db = await openDB();
    await getSharedPreferences();
  }

  /// Open the database with the given [name] and [structure].
  ///
  /// If the database does not exist, it will be created.
  ///
  /// If the database exists, it will be opened.
  ///
  /// You can pass a [String] [name] argument to name the database you want to create or open.
  ///
  /// You can pass a [TableStruct] [structure] argument to define the structure of the database you want to create.
  ///
  /// If you don't pass a [TableStruct] [structure] argument, the default Cache(uuid, data, metadata) structure will be used.
  Future<Database> openDB({String? name = 'minima_cache.db', TableStruct? structure}) async {
    structure ??= TableStruct();
    final database = await openDatabase(
      join(await getDatabasesPath(), name),
      onCreate: (db, version) {
        return db.execute(
          '''
            CREATE TABLE IF NOT EXISTS cache(
              uuid TEXT PRIMARY KEY,
              data TEXT,
              metadata TEXT,
              createdAt TIMESTAMP,
              lastUpdatedAt TIMESTAMP,
            );
          ''',
        );
      },
      version: 1,
    );

    return database;
  }

  Future<void> getSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> cacheStore(String uuid, String data, String? metadata, ConflictAlgorithm? conflictAlgorithm) async {
    try {
      if (!_db.isOpen) {
        _db = await openDB();
      }
      int changes = 0;
      bool uuidExists = (await _db.rawQuery('''SELECT * FROM cache WHERE uuid = ?''', [uuid])).isNotEmpty;
      if (uuidExists) {
        changes = await _db.rawUpdate(
          '''
            UPDATE cache
            SET data = ?, metadata = ?, lastUpdatedAt = ?
            WHERE uuid = ?
          ''',
          [data, metadata, DateTime.now(), uuid],
        );
      } else {
        changes = await _db.rawInsert(
          '''
            INSERT INTO cache(uuid, data, metadata, createdAt, lastUpdatedAt)
            VALUES (uuid = ?, data = ?, metadata = ?, createdAt = ?, lastUpdatedAt = ?)
          ''',
          [uuid, data, metadata, DateTime.now(), DateTime.now()],
        );
      }
      if (changes > 0) return true;
    } catch (e) {
      log('Cache Error @cache_service.store: $e');
    } finally {
      await _db.close();
    }
    return false;
  }
}

class TableStruct {
  String tableName;
  Map<String, String> fields;

  TableStruct({
    this.tableName = 'cache',
    this.fields = const {
      'uuid': 'TEXT PRIMARY KEY',
      'data': 'TEXT',
      'metadata': 'TEXT',
    },
  });
}
