import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/phrase.dart';
import '../models/scan_result.dart';

/// SQLiteでお気に入り・履歴を永続化するサービス
class DatabaseService {
  static Database? _database;
  static const String _dbName = 'snap_english.db';
  static const int _dbVersion = 1;

  /// シングルトン
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  /// DB取得（初回は自動作成）
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(documentsDir.path, _dbName);

      return await openDatabase(
        dbPath,
        version: _dbVersion,
        onCreate: _createTables,
      );
    } catch (e) {
      // DB破損時はファイルを削除して再作成を試みる
      try {
        final documentsDir = await getApplicationDocumentsDirectory();
        final dbPath = p.join(documentsDir.path, _dbName);
        final dbFile = File(dbPath);
        if (await dbFile.exists()) {
          await dbFile.delete();
        }
        return await openDatabase(
          dbPath,
          version: _dbVersion,
          onCreate: _createTables,
        );
      } catch (_) {
        rethrow;
      }
    }
  }

  /// テーブル作成
  Future<void> _createTables(Database db, int version) async {
    // スキャン履歴テーブル
    await db.execute('''
      CREATE TABLE scan_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        scanned_at TEXT NOT NULL
      )
    ''');

    // フレーズテーブル
    await db.execute('''
      CREATE TABLE phrases (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scan_id INTEGER NOT NULL,
        english TEXT NOT NULL,
        japanese TEXT NOT NULL,
        difficulty TEXT NOT NULL DEFAULT 'beginner',
        is_favorite INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (scan_id) REFERENCES scan_history (id) ON DELETE CASCADE
      )
    ''');
  }

  // ============ スキャン履歴 ============

  /// スキャン結果をDB保存し、画像をアプリ内にコピー
  Future<int> saveScanResult(String imagePath, List<Phrase> phrases) async {
    final db = await database;

    // 画像をアプリのドキュメントディレクトリにコピー
    final savedPath = await _copyImageToAppDir(imagePath);

    // スキャン履歴を挿入
    final scanId = await db.insert('scan_history', {
      'image_path': savedPath,
      'scanned_at': DateTime.now().toIso8601String(),
    });

    // フレーズを挿入
    for (final phrase in phrases) {
      await db.insert('phrases', {
        'scan_id': scanId,
        'english': phrase.english,
        'japanese': phrase.japanese,
        'difficulty': phrase.difficulty,
        'is_favorite': 0,
        'created_at': phrase.createdAt.toIso8601String(),
      });
    }

    return scanId;
  }

  /// 画像をアプリ内ディレクトリにコピー
  Future<String> _copyImageToAppDir(String originalPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(dir.path, 'images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final fileName = 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final newPath = p.join(imagesDir.path, fileName);

    final originalFile = File(originalPath);
    if (await originalFile.exists()) {
      await originalFile.copy(newPath);
    }

    return newPath;
  }

  /// 全スキャン履歴を取得（新しい順）
  Future<List<ScanResult>> getAllScanHistory() async {
    final db = await database;

    final scans = await db.query(
      'scan_history',
      orderBy: 'scanned_at DESC',
    );

    final results = <ScanResult>[];
    for (final scan in scans) {
      final phrases = await db.query(
        'phrases',
        where: 'scan_id = ?',
        whereArgs: [scan['id']],
      );

      results.add(ScanResult(
        id: scan['id'] as int,
        imagePath: scan['image_path'] as String,
        phrases: phrases.map((p) => Phrase(
          id: p['id'] as int,
          english: p['english'] as String,
          japanese: p['japanese'] as String,
          difficulty: p['difficulty'] as String,
          isFavorite: (p['is_favorite'] as int) == 1,
          createdAt: DateTime.parse(p['created_at'] as String),
        )).toList(),
        scannedAt: DateTime.parse(scan['scanned_at'] as String),
      ));
    }

    return results;
  }

  /// スキャン履歴を削除
  Future<void> deleteScanResult(int scanId) async {
    final db = await database;
    // フレーズも CASCADE で消える
    await db.delete('scan_history', where: 'id = ?', whereArgs: [scanId]);
  }

  // ============ お気に入り ============

  /// お気に入りトグル
  Future<bool> toggleFavorite(int phraseId) async {
    final db = await database;
    final current = await db.query(
      'phrases',
      columns: ['is_favorite'],
      where: 'id = ?',
      whereArgs: [phraseId],
    );

    if (current.isEmpty) return false;

    final newValue = (current.first['is_favorite'] as int) == 1 ? 0 : 1;
    await db.update(
      'phrases',
      {'is_favorite': newValue},
      where: 'id = ?',
      whereArgs: [phraseId],
    );

    return newValue == 1;
  }

  /// お気に入り一覧を取得（新しい順）
  Future<List<Phrase>> getFavorites() async {
    final db = await database;
    final results = await db.query(
      'phrases',
      where: 'is_favorite = 1',
      orderBy: 'created_at DESC',
    );

    return results.map((p) => Phrase(
      id: p['id'] as int,
      english: p['english'] as String,
      japanese: p['japanese'] as String,
      difficulty: p['difficulty'] as String,
      isFavorite: true,
      createdAt: DateTime.parse(p['created_at'] as String),
    )).toList();
  }

  /// お気に入り解除
  Future<void> removeFavorite(int phraseId) async {
    final db = await database;
    await db.update(
      'phrases',
      {'is_favorite': 0},
      where: 'id = ?',
      whereArgs: [phraseId],
    );
  }

  /// 履歴件数を取得
  Future<int> getScanCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM scan_history');
    return result.first['count'] as int;
  }

  /// お気に入り件数を取得
  Future<int> getFavoriteCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM phrases WHERE is_favorite = 1');
    return result.first['count'] as int;
  }

  /// 今日のスキャン回数を取得（無料制限チェック用）
  Future<int> getTodayScanCount() async {
    final db = await database;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day).toIso8601String();
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59).toIso8601String();

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM scan_history WHERE scanned_at BETWEEN ? AND ?',
      [startOfDay, endOfDay],
    );
    return result.first['count'] as int;
  }
}
