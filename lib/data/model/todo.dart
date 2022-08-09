import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Todo {
  int? id;
  String? title;
  Todo({this.id, this.title});

  factory Todo.fromMap(Map<String, dynamic> data) {
    return Todo(
      id: data['id'],
      title: data['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory doucumentDirectory = await getApplicationDocumentsDirectory();
    String path = join(doucumentDirectory.path, 'todos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE todos(
      id INTEGER PRIMARY KEY,
      title TEXT 
    )
''');
  }

  Future<List<Todo>> getTodos() async {
    Database db = await instance.database;
    var todos = await db.query('todos', orderBy: 'title');
    List<Todo> todoList = todos.isNotEmpty
        ? todos.map((todo) => Todo.fromMap(todo)).toList()
        : [];

    return todoList;
  }

  Future<int> addTodo(Todo todo) async {
    Database db = await instance.database;
    return await db.insert('todos', todo.toMap());
  }
}
