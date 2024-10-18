import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDBService {
  static final LocalDBService _instance = LocalDBService._internal();
  static Database? _database;

  LocalDBService._internal();

  factory LocalDBService() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, lastMod INTEGER)',
        );
      },
    );
  }

  Future<void> saveNote({required Note note}) async {
    final db = await database;
    if (note.id == null) {
      await db.insert('notes', note.toMap());
    } else {
      await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    }
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Stream<List<Note>> listenAllNotes() async* {
    while (true) {
      yield await getAllNotes();
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<void> deleteNote({required int id, required BuildContext context}) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note deleted')));
  }
}