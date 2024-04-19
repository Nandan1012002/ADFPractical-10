import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/city.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = getDirectory.path + '/city.db';
    log(path);
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE City ( id INTEGER PRIMARY KEY AUTOINCREMENT, CityName TEXT, CityDescription TEXT )');
    log('TABLE CREATED');
  }

  Future<List<City>> getCity() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic?>> queryResult = await db.query('City');
    return queryResult.map((e) => City.fromMap(e)).toList();
  }

  Future<void> insertCity(City city) async {
    final db = await _databaseService.database;
    var data = await db.insert('City', city.toMap());
    log('inserted $data');
  }

  Future<void> editCity(City city) async {
    final db = await _databaseService.database;
    var data = await db.rawUpdate(
        'UPDATE City SET CityName=?, CityDescription=? WHERE ID=?',
        [city.cityName, city.cityDescription, city.id]);
    log('Updated $data');
  }

  Future<void> deleteCity(int id) async {
    final db = await _databaseService.database;
    var data = await db.rawDelete('DELETE FROM City WHERE id=?', [id]);
    log('deleted $data');
  }
}