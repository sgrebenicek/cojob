import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
    };
  }
}

class DatabaseService {
  static Database? _database;

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = await openDatabase(
      join(await getDatabasesPath(), 'cojob.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, first_name VARCHAR NOT NULL, last_name VARCHAR NOT NULL, email VARCHAR NOT NULL, password VARCHAR NOT NULL)');
      },
      version: 1,
    );
  }

  static Future<Database> get database async {
    if (_database != null) return _database!;
    await initialize();
    return _database!;
  }

  static Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }
}
