import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop/Views/orderHistoryPage.dart';
import 'package:shop/database/orderDBHelper.dart';
import 'package:shop/models/order_Model.dart';
import 'package:shop/models/user_model.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({super.key, required this.userModel});

  UserModel userModel;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future<List<OrderModel>>? orderlist;

  late OrderDatabaseHelper orderdb;

  getrefresh() {
    orderdb = OrderDatabaseHelper();

    setState(() {
      orderlist = orderdb.GetUnpaidProductByUserId(widget.userModel.id!);
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
              "Shopping Cart",
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      OrderHistoryScreen(userModel: widget.userModel),
                ));
              },
              icon: Icon(
                Icons.history,
                color: Colors.black,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 80,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_pin_circle,
                        size: 50,
                      ),
                      Text(
                        'Address',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.arrow_forward_ios))
                ],
              ),
            ),
            FutureBuilder(
              future: orderlist,
              builder: (BuildContext context,
                  AsyncSnapshot<List<OrderModel>> snapshot) {
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
                  physics: NeverScrollableScrollPhysics(),
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
                              Container(
                                color: Color(0xFFf2f2f2),
                                child: Row(
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size(50, 30),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () async {
                                        if (order.orderQty! > 1) {
                                          double total = 0;
                                          total = double.parse(
                                                  order.productPrice!) *
                                              (order.orderQty! - 1);
                                          await OrderDatabaseHelper()
                                              .updateData(OrderModel(
                                                  orderid: order.orderid,
                                                  productId: order.productId,
                                                  orderQty: order.orderQty! - 1,
                                                  payment: order.payment,
                                                  userId: order.userId,
                                                  total: total.toString()));
                                          getrefresh();
                                        } else {
                                          await OrderDatabaseHelper()
                                              .deleteData(
                                                  order.orderid!,
                                                  order.productId!,
                                                  order.userId!);
                                          getrefresh();
                                        }
                                      },
                                      child: Text('-',
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                    Text(order.orderQty!.toString()),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size(50, 30),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () async {
                                        double total = 0;
                                        total =
                                            double.parse(order.productPrice!) *
                                                (order.orderQty! + 1);
                                        await OrderDatabaseHelper().updateData(
                                            OrderModel(
                                                orderid: order.orderid,
                                                productId: order.productId,
                                                orderQty: order.orderQty! + 1,
                                                payment: order.payment,
                                                userId: order.userId,
                                                total: total.toString()));
                                        getrefresh();
                                      },
                                      child: Text(
                                        '+',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ]),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 120,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Ammount",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: orderlist,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<OrderModel>> snapshot) {
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
                    double totalprice = 0;
                    for (var order in snapshot.data!) {
                      totalprice += double.parse(order.total!);
                    }

                    return Text(
                      "\$" + totalprice.toString(),
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
            FutureBuilder(
              future: orderlist,
              builder: (BuildContext context,
                  AsyncSnapshot<List<OrderModel>> snapshot) {
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
                return ElevatedButton(
                  onPressed: () async {
                    if (snapshot.data!.length == 0) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: Text('No Product'),
                              content: Text('Please Select Products'));
                        },
                      );
                    } else {
                      await OrderDatabaseHelper()
                          .updateDataWhenPay(widget.userModel.id!)
                          .whenComplete(() {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: Text('Payment Complete'),
                                content: Text('Thank you For Your Purchase'));
                          },
                        );
                        getrefresh();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color(0XFF585858),
                  ),
                  child: Text("Pay Now!"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
