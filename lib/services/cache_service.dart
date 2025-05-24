import 'dart:developer';

import 'package:minima_notes/models/query_response_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static final CacheService _cacheService = CacheService._();

  static CacheService get instance => _cacheService;

  CacheService._() {
    _init();
  }

  Database? _db;
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
            CREATE TABLE IF NOT EXISTS note(
              uuid TEXT PRIMARY KEY,
              data TEXT,
              metadata TEXT,
              createdAt TIMESTAMP,
              lastUpdatedAt TIMESTAMP
            )
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

  Future<bool> store(String uuid, String data, String? metadata, {String table = 'note'}) async {
    try {
      if (_db == null || !_db!.isOpen) {
        _db = await openDB();
      }
      int changes = 0;
      bool uuidExists = (await _db!.rawQuery('''SELECT * FROM $table WHERE uuid = ?''', [uuid])).isNotEmpty;
      if (uuidExists) {
        changes = await _db!.rawUpdate(
          '''
            UPDATE $table
            SET data = ?, metadata = ?, lastUpdatedAt = ?
            WHERE uuid = ?
          ''',
          [
            data,
            metadata,
            DateTime.now().toIso8601String(),
            uuid,
          ],
        );
      } else {
        changes = await _db!.rawInsert(
          '''
            INSERT INTO $table(uuid, data, metadata, createdAt, lastUpdatedAt)
            VALUES (?, ?, ?, ?, ?)
          ''',
          [
            uuid,
            data,
            metadata,
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String(),
          ],
        );
      }
      if (changes > 0) return true;
    } catch (e) {
      log('Cache Error @cache_service.store: $e');
    } finally {
      await _db!.close();
    }
    return false;
  }

  Future<bool> remove(String uuid, {String table = 'note'}) async {
    try {
      if (_db == null || !_db!.isOpen) {
        _db = await openDB();
      }
      int deleted = 0;
      bool uuidExists = (await _db!.rawQuery('''SELECT * FROM $table WHERE uuid = ?''', [uuid])).isNotEmpty;
      if (uuidExists) {
        deleted = await _db!.rawUpdate(
          '''
            DELETE FROM $table
            WHERE uuid = ?
          ''',
          [uuid],
        );
      }
      if (deleted > 0) return true;
    } catch (e) {
      log('Cache Error @cache_service.remnove: $e');
    } finally {
      await _db!.close();
    }
    return false;
  }

  Future<QueryResponseModel> getByUuid(String uuid, {String table = 'note'}) async {
    if (_db == null || !_db!.isOpen) {
      _db = await openDB();
    }
    List<Map<String, dynamic>>? res;
    try {
      res = await _db!.rawQuery(
        '''
          SELECT * FROM $table WHERE uuid = ?
        ''',
        [uuid],
      );
    } catch (e) {
      log('Cache Error @cache_service.getByUuid: $e');
    } finally {
      await _db!.close();
    }
    if (res != null) {
      if (res.length == 1) {
        return QueryResponseModel(status: '000', msg: 'Retrieval successful!', data: res);
      } else if (res.length > 1) {
        return QueryResponseModel(status: '020', msg: 'Multiple entries with same UUID!', data: null);
      } else {
        return QueryResponseModel(status: '010', msg: 'No entry found!', data: null);
      }
    } else {
      return QueryResponseModel(status: '100', msg: 'Query error!', data: null);
    }
  }

  Future<QueryResponseModel> getAll({String table = 'note'}) async {
    if (_db == null || !_db!.isOpen) {
      _db = await openDB();
    }
    List<Map<String, dynamic>>? res;
    try {
      res = await _db!.rawQuery(
        '''
          SELECT * FROM $table
        ''',
      );
    } catch (e) {
      log('Cache Error @cache_service.getAll: $e');
    } finally {
      await _db!.close();
    }
    if (res != null) {
      if (res.isNotEmpty) {
        return QueryResponseModel(status: '000', msg: 'Retrieval successful!', data: res);
      } else {
        return QueryResponseModel(status: '010', msg: 'No entry found!', data: null);
      }
    } else {
      return QueryResponseModel(status: '100', msg: 'Query error!', data: null);
    }
  }
}

class TableStruct {
  String tableName;
  Map<String, String> fields;

  TableStruct({
    this.tableName = 'note',
    this.fields = const {
      'uuid': 'TEXT PRIMARY KEY',
      'data': 'TEXT',
      'metadata': 'TEXT',
      'createdAt': 'TIMESTAMP',
      'lastUpdatedAt': 'TIMESTAMP',
    },
  });
}
