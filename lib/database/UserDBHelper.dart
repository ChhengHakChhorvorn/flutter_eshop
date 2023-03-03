import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop/models/user_model.dart';
import 'package:shop/utils/categories_prop.dart';
import 'package:shop/utils/order_prop.dart';
import 'package:shop/utils/product_prop.dart';
import 'package:shop/utils/user_prop.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseStucture {
  Future<Database> initializeDatabase();
  Future<void> insertData(UserModel userModel);
  Future<void> updateData(UserModel userModel);
  Future<void> deleteData(int id);
  Future<List<UserModel>> getUserData();
}

class UserDatabaseHelper extends DatabaseStucture {
  @override
  Future<void> deleteData(int id) async {
    final db = await initializeDatabase();
    await db.delete(userTable, where: '$fid=?', whereArgs: [id]);
  }

  @override
  Future<List<UserModel>> getUserData() async {
    var db = await initializeDatabase();
    List<Map<String, dynamic>> result = await db.query(userTable);
    return result.map((e) => UserModel.userModelFromJson(e)).toList();
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
          'CREATE TABLE $userTable($fid INTEGER PRIMARY KEY, $fname TEXT, $femail TEXT, $fpassword TEXT, $fimgpath TEXT)');
      await db.execute(
          'CREATE TABLE $categoryTable($fcategoryid INTEGER PRIMARY KEY, $fcategoryName TEXT, $fdesc TEXT, $fcategoryimgpath TEXT)');
      await db.execute(
          'CREATE TABLE $productTable($fproductid INTEGER PRIMARY KEY, $fproductname TEXT, $fproductdesc TEXT, $fproductprice TEXT,$fproductqty TEXT, $fproductcategory TEXT,$fproductimgpath TEXT)');
      await db.execute(
          'CREATE TABLE $orderTable($forderid INTEGER , $fproductIdorder INTEGER, $fuserId INTEGER, $forderqty INTEGER ,$ftotal TEXT, $fpayment TEXT)');
    }), version: 1);
  }

  @override
  Future<void> insertData(UserModel userModel) async {
    var db = await initializeDatabase();
    db.insert(userTable, userModel.userModelToJson());
  }

  @override
  Future<void> updateData(UserModel userModel) async {
    final db = await initializeDatabase();
    await db.update(userTable, userModel.userModelToJson(),
        where: '$fid=?', whereArgs: [userModel.id]);
  }
}
