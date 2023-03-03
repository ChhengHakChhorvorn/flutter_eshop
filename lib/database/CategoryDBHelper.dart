import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop/utils/categories_prop.dart';
import 'package:sqflite/sqflite.dart';
import '../models/category_model.dart';
import 'package:path/path.dart';

abstract class DatabaseStuctureCategory {
  Future<Database> initializeDatabase();
  Future<void> insertData(CategoryModel categoryModel);
  Future<void> updateData(CategoryModel categoryModel);
  Future<void> deleteData(int id);
  Future<List<CategoryModel>> getUserData();
}

class CategoryDatabaseHelper extends DatabaseStuctureCategory {
  @override
  Future<void> deleteData(int id) async {
    final db = await initializeDatabase();
    await db.delete(categoryTable, where: '$fcategoryid=?', whereArgs: [id]);
  }

  @override
  Future<List<CategoryModel>> getUserData() async {
    var db = await initializeDatabase();
    List<Map<String, dynamic>> result = await db.query(categoryTable);
    return result.map((e) => CategoryModel.CategoryModelFromJson(e)).toList();
  }

  @override
  Future<Database> initializeDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var databasesPath = await getDatabasesPath();
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'userdb.db'),
        onCreate: ((db, version) async {
      await db.execute(
          'CREATE TABLE $categoryTable($fcategoryid INTEGER PRIMARY KEY, $fcategoryName TEXT, $fdesc TEXT, $fcategoryimgpath TEXT)');
    }), version: 1);
  }

  @override
  Future<void> insertData(CategoryModel categoryModel) async {
    final db = await initializeDatabase();
    await db.insert(categoryTable, categoryModel.CategoryModelToJson());
  }

  @override
  Future<void> updateData(CategoryModel categoryModel) async {
    final db = await initializeDatabase();
    await db.update(categoryTable, categoryModel.CategoryModelToJson(),
        where: '$fcategoryid=?', whereArgs: [categoryModel.id]);
  }
}
