/// File: lib/core/local_db/sqflite_helper.dart
/// Purpose: SQLite database helper for local caching
/// Belongs To: shared
/// Customization Guide:
///    - Add new tables in _onCreate
///    - Add CRUD methods for each table

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/app_constants.dart';

/// SQLite database helper for local caching.
class SqfliteHelper {
  SqfliteHelper._();
  
  static final SqfliteHelper instance = SqfliteHelper._();
  
  Database? _database;
  
  /// Get database instance.
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }
  
  /// Initialize database.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);
    
    return openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  /// Create database tables.
  Future<void> _onCreate(Database db, int version) async {
    // Stations cache table
    await db.execute('''
      CREATE TABLE stations (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    
    // Bookings cache table
    await db.execute('''
      CREATE TABLE bookings (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    
    // User cache table
    await db.execute('''
      CREATE TABLE user_cache (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    
    // Search history table
    await db.execute('''
      CREATE TABLE search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        query TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
  }
  
  /// Handle database upgrades.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Add migration logic here when needed
  }
  
  // ============ Generic CRUD Operations ============
  
  /// Insert or update a record.
  Future<void> upsert(String table, String id, String data) async {
    final db = await database;
    await db.insert(
      table,
      {
        'id': id,
        'data': data,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  /// Get a record by ID.
  Future<String?> getById(String table, String id) async {
    final db = await database;
    final result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return result.first['data'] as String;
  }
  
  /// Get all records from a table.
  Future<List<String>> getAll(String table) async {
    final db = await database;
    final result = await db.query(table);
    return result.map((r) => r['data'] as String).toList();
  }
  
  /// Delete a record by ID.
  Future<void> deleteById(String table, String id) async {
    final db = await database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
  
  /// Clear a table.
  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }
  
  /// Clear all tables.
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('stations');
    await db.delete('bookings');
    await db.delete('user_cache');
    await db.delete('search_history');
  }
  
  // ============ Search History ============
  
  /// Add search query to history.
  Future<void> addSearchHistory(String query) async {
    final db = await database;
    await db.insert('search_history', {
      'query': query,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  /// Get recent search history.
  Future<List<String>> getSearchHistory({int limit = 10}) async {
    final db = await database;
    final result = await db.query(
      'search_history',
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return result.map((r) => r['query'] as String).toList();
  }
  
  /// Clear search history.
  Future<void> clearSearchHistory() async {
    await clearTable('search_history');
  }
  
  /// Close database.
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}

