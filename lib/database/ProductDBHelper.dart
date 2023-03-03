import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/utils/product_prop.dart';
import 'package:sqflite/sqflite.dart';
import '../models/category_model.dart';
import 'package:path/path.dart';

abstract class DatabaseStuctureProduct {
  Future<Database> initializeDatabase();
  Future<void> insertData(ProductModel productModel);
  Future<void> updateData(ProductModel productModel);
  Future<void> deleteData(int id);
  Future<List<ProductModel>> getProductData();
}

class ProductDatabaseHelper extends DatabaseStuctureProduct {
  @override
  Future<void> deleteData(int id) async {
    final db = await initializeDatabase();
    await db.delete(productTable, where: '$fproductid=?', whereArgs: [id]);
  }

  @override
  Future<List<ProductModel>> getProductData() async {
    var db = await initializeDatabase();
    List<Map<String, dynamic>> result = await db.query(productTable);
    return result.map((e) => ProductModel.ProductModelFromJson(e)).toList();
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
          'CREATE TABLE $productTable($fproductid INTEGER PRIMARY KEY, $fproductname TEXT, $fproductdesc TEXT, $fproductprice TEXT,$fproductqty TEXT, $fproductcategory TEXT,$fproductimgpath TEXT)');
    }), version: 1);
  }

  @override
  Future<void> insertData(ProductModel productModel) async {
    final db = await initializeDatabase();
    await db.insert(productTable, productModel.ProductModelToJson());
  }

  @override
  Future<void> updateData(ProductModel productModel) async {
    final db = await initializeDatabase();
    await db.update(productTable, productModel.ProductModelToJson(),
        where: '$fproductid=?', whereArgs: [productModel.id]);
  }
}
