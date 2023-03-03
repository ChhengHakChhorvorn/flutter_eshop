import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop/models/user_model.dart';

import '../database/orderDBHelper.dart';
import '../models/order_Model.dart';

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({super.key, required this.userModel});
  UserModel userModel;

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  Future<List<OrderModel>>? orderlist;

  late OrderDatabaseHelper orderdb;

  getrefresh() {
    orderdb = OrderDatabaseHelper();

    setState(() {
      orderlist = orderdb.GetPaidProductByUserId(widget.userModel.id!);
    });
  }

  @override
  void initState() {
    super.initState();
    getrefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              "Order History",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDB9E00)),
            )
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder(
        future: orderlist,
        builder:
            (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Icon(
                Icons.info,
                color: Colors.red,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var order = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    Container(
                        width: 130,
                        height: 130,
                        child: order.productImgPath != null
                            ? Image.file(File(order.productImgPath!))
                            : null),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.productName!),
                        Text(order.productDesc!),
                        Text("\$" + order.productPrice!),
                        Text("Quantity: " + order.orderQty!.toString()),
                        Text("Total: \$" + order.total!)
                      ],
                    )
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
