import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/work.dart';
class WorkDatabase {
  static Future<Database> openDB() async{
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'work_database.db'),
      version: 1,
     onCreate: (db, version) async {
       await db.execute('''
   CREATE TABLE works (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      is_completed INTEGER NOT NULL DEFAULT 0
    )
    
  ''');
     },
onOpen: (db) async {
final result = await db.rawQuery(
'SELECT COUNT(*) FROM works',
);

final count = Sqflite.firstIntValue(result) ?? 0;

if (count == 0) {
  await db.insert('works', {
    'name': 'Làm bài tập Flutter',
    'description': 'Hoàn thành trước thứ Sáu',
    'is_completed': 0,
  });

  await db.insert('works', {
    'name': 'Ôn tập Riverpod',
    'description': 'Xem lại bài giảng MVVM',
    'is_completed': 0,
  });

  await db.insert('works', {
    'name': 'Chuẩn bị bài thuyết trình',
    'description': 'Nhóm 4 - Chủ đề Firebase',
    'is_completed': 0,
  });

  await db.insert('works', {
    'name': 'Viết báo cáo môn học',
    'description': 'Nộp trên LMS',
     'is_completed': 0,});
}
},
    );
  }

  static Future<int> insertWorks(Work work) async {
    final db = await openDB();
    final id = await db.insert('works', work.toMap(),);
    return id;

  }
  static Future<List<Work>> getWorks() async {
    final db = await openDB();
    final maps = await db.query('works');
    final works = maps.map((map){
      return Work.fromMap(map);
    }).toList();
    return works;
  }
  static Future<int> updateWork(Work work) async {
    final db = await openDB();
    final data = work.toMap()..remove('id');
    final result = await db.update(
      'works',
      data,
      where: 'id = ?',
      whereArgs: [work.id],
    );
    return result;
  }
}