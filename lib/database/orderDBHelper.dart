import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop/models/order_Model.dart';
import 'package:shop/utils/order_prop.dart';
import 'package:shop/utils/product_prop.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DatabaseStuctureOrder {
  Future<Database> initializeDatabase();
  Future<void> insertData(OrderModel orderModel);
  Future<void> updateData(OrderModel orderModel);
  Future<void> updateDataWhenPay(int userId);
  Future<void> deleteData(int orderid, int prdouctid, int userid);
  Future<List<OrderModel>> GetUnpaidProductByUserId(int userid);
  Future<List<OrderModel>> GetPaidProductByUserId(int userid);
}

class OrderDatabaseHelper extends DatabaseStuctureOrder {
  @override
  Future<void> deleteData(int orderid, int prdouctid, int userid) async {
    final db = await initializeDatabase();
    await db.rawQuery(
        "DELETE FROM $orderTable WHERE $forderid = $orderid AND $fproductIdorder = $prdouctid AND $fuserId = $userid ");
  }

  @override
  Future<List<OrderModel>> GetUnpaidProductByUserId(int userid) async {
    final db = await initializeDatabase();
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT $forderid, $fproductIdorder, $fproductname, $fproductprice, $fproductdesc,$fproductimgpath, $fuserId, $forderqty, $ftotal, $fpayment FROM $orderTable O INNER JOIN $productTable P ON O.$fproductIdorder = P.$fproductid  WHERE $fuserId = $userid AND $fpayment = '0' ");

    return result.map((e) => OrderModel.OrderModelFromJson(e)).toList();
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
          'CREATE TABLE $orderTable($forderid INTEGER , $fproductIdorder INTEGER, $fuserId INTEGER, $forderqty INTEGER ,$ftotal TEXT, $fpayment TEXT)');
    }), version: 1);
  }

  @override
  Future<void> insertData(OrderModel orderModel) async {
    final db = await initializeDatabase();
    db.insert(orderTable, orderModel.OrderModelToJson());
  }

  @override
  Future<void> updateData(OrderModel orderModel) async {
    final db = await initializeDatabase();
    db.update(orderTable, orderModel.OrderModelToJson(),
        where: "$forderid=? AND $fproductIdorder=? AND $fuserId=?",
        whereArgs: [
          orderModel.orderid,
          orderModel.productId,
          orderModel.userId
        ]);
  }

  @override
  Future<List<OrderModel>> GetPaidProductByUserId(int userid) async {
    final db = await initializeDatabase();
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT $forderid, $fproductIdorder, $fproductname, $fproductprice, $fproductdesc,$fproductimgpath, $fuserId, $forderqty, $ftotal, $fpayment FROM $orderTable O INNER JOIN $productTable P ON O.$fproductIdorder = P.$fproductid  WHERE $fuserId = $userid AND $fpayment = '1' ");
    return result.map((e) => OrderModel.OrderModelFromJson(e)).toList();
  }

  @override
  Future<void> updateDataWhenPay(int userId) async {
    final db = await initializeDatabase();
    await db.rawQuery(
        " UPDATE $orderTable SET $fpayment = '1' WHERE $fuserId = $userId");
  }
}
