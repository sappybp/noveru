import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper {
  static const _databaseName = "noveru_database.db";
  static const _databaseTableNameBooks = "books";
  static const _databaseTableNameBooksRating = "books_rating";
  static const _databaseVersion = 1;

  static DatabaseHelper? _instance;
  DatabaseHelper._();
  static DatabaseHelper get instance => _instance ??= DatabaseHelper._();

  factory DatabaseHelper() => instance;

  // データベースのインスタンス生成
  Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  // DB作成1
  _initDatabase() async {
    String path = await getDbPath();
    final dbOpen = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );

    // データベースからレコード数取得
    final recordCount = await dbOpen.rawQuery(' Select count(id) from $_databaseTableNameBooks');
    // print('recordCount[0][count(id)]:${recordCount[0]['count(id)']}');
    if (recordCount[0]['count(id)'] == 0) {
      //データ0件 初期Insert処理
      await _insertInitBook(dbOpen);
    }

    return dbOpen;
  }

  Future<void> _onCreate(Database db, int version) async {
    // データベース内にテーブルを作成
    await db.execute('''
      CREATE TABLE $_databaseTableNameBooks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        author TEXT,
        synopsis TEXT,
        genre INTEGER,
        createdAt TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE $_databaseTableNameBooksRating (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_id INTEGER,
        rating INTEGER,
        createdAt TEXT
      );
    ''');
  }

  Future<String> getDbPath() async {
    var dbFilePath = '';

    if (Platform.isAndroid) {
      // Androidであれば「getDatabasesPath」を利用
      dbFilePath = await getDatabasesPath();
    } else if (Platform.isIOS) {
      // iOSであれば「getLibraryDirectory」を利用
      final dbDirectory = await getLibraryDirectory();
      dbFilePath = dbDirectory.path;
    } else {
      // プラットフォームが判別できない場合はExceptionをthrow
      // 簡易的にExceptionをつかったが、自作Exceptionの方がよいと思う。
      throw Exception('Unable to determine platform.');
    }
    // 配置場所のパスを作成して返却
    final path = join(dbFilePath, _databaseName);
    return path;
  }

// 本の初期データ追加
  Future<void> _insertInitBook(Database db) async {
    final dateNow = DateTime.now().toString();
    // データベースに初期値を挿入
    final rows = await getCsvData();
    // CSV データのパース処理
    for (var row in rows) {
      // print('row[0]:${row[0]}');
      await db.insert(_databaseTableNameBooks,{
        'title': row[0],
        'author': row[1],
        'synopsis': row[2],
        'genre' : row[3],
        'createdAt':dateNow
      });
    }
  }

  Future<List<List<dynamic>>> getCsvData() async {
    // Assetにある CSV ファイルの読み込み
    final csvDataString = await rootBundle.loadString('assets/noveru.csv');
    // CSVデータをリストに変換
    List<List<dynamic>> rows = const CsvToListConverter().convert(csvDataString);

    return rows;
  }

  // 本のデータ取得
  Future<List<Map<String, dynamic>>> selectBook10() async {
    try {
      final db = await database;
      // 10件のbooksデータを取得
      final List<Map<String, dynamic>> books =
      // print('selectBook10: $books');
      await db.rawQuery('''
        Select
        $_databaseTableNameBooks.id,
        $_databaseTableNameBooks.title,
        $_databaseTableNameBooks.author,
        $_databaseTableNameBooks.synopsis,
        $_databaseTableNameBooks.genre
        from $_databaseTableNameBooks
        left outer join $_databaseTableNameBooksRating on
        $_databaseTableNameBooks.id = $_databaseTableNameBooksRating.book_id
        where $_databaseTableNameBooksRating.id is null
        order by random()
        limit 10;
        ''');

      return books;

    } catch (e) {
      throw Exception('selectBook10():データ取得に失敗しました');
    }
  }

  //本の評価データ追加
  Future<void> insertBookRating(int id, int rating) async {
    // print('insertBookRating');
    try {
      final db = await database;
      final dateNow = DateTime.now().toString();
      // データ追加
      await db.insert(_databaseTableNameBooksRating, {'book_id': id, 'rating': rating, 'createdAt':dateNow});

    } catch(e) {
      throw Exception('insertBookRating:データ追加に失敗しました');
    }
  }

  //本の評価データ(単体)削除
  Future<void> deleteBookRating(int id) async {
    // print('deleteBookRating');
    final db = await database;
    await db.rawDelete('''
      DELETE FROM $_databaseTableNameBooksRating
        WHERE book_id = $id
      ''');
  }

  // 本の評価データ取得
  Future<List<Map<String, dynamic>>> selectBookRating() async {
    try {
      final db = await database;
      // 10件のbooksデータを取得
      final List<Map<String, dynamic>> booksRating =
      await db.rawQuery('''
        Select
        $_databaseTableNameBooks.id,
        $_databaseTableNameBooks.title,
        $_databaseTableNameBooks.author,
        $_databaseTableNameBooks.synopsis,
        $_databaseTableNameBooks.genre,
        $_databaseTableNameBooksRating.rating
        from $_databaseTableNameBooks
        inner join $_databaseTableNameBooksRating on
        $_databaseTableNameBooks.id = $_databaseTableNameBooksRating.book_id
        where $_databaseTableNameBooksRating.rating = 0
        order by $_databaseTableNameBooksRating.createdAt desc
        ''');
      // print('selectBookRating: $booksRating');
      return booksRating;

    } catch (e) {
      throw Exception('selectBookRating():データ取得に失敗しました');
    }
  }

  //本の評価データ(0:お気に入りor1:削除)削除
  Future<void> deleteSomeBookRatings(int rating) async {
    // print('deleteSomeBookRatings');
    final db = await database;
    await db.rawDelete('''
    DELETE FROM $_databaseTableNameBooksRating
      WHERE rating = $rating
    ''');
  }

}