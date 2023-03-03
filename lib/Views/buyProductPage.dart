import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/Views/orderPage.dart';
import 'package:shop/database/ProductDBHelper.dart';
import 'package:shop/database/orderDBHelper.dart';
import 'package:shop/models/order_Model.dart';
import 'package:shop/models/user_model.dart';

import '../models/product_model.dart';

class BuyProductScreen extends StatefulWidget {
  BuyProductScreen(
      {super.key, required this.usermodel, required this.productModel});

  UserModel usermodel;
  ProductModel productModel;

  @override
  State<BuyProductScreen> createState() => _BuyProductScreenState();
}

class _BuyProductScreenState extends State<BuyProductScreen> {
  Future<List<ProductModel>>? productList;
  Future<List<OrderModel>>? orderList;

  late ProductDatabaseHelper productdb;
  late OrderDatabaseHelper orderdb;

  getRefresh() {
    productdb = ProductDatabaseHelper();
    orderdb = OrderDatabaseHelper();

    setState(() {
      productList = productdb.getProductData();
      orderList = orderdb.GetUnpaidProductByUserId(widget.usermodel.id!);
    });
  }

  @override
  void initState() {
    super.initState();
    getRefresh();
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
              widget.productModel.name!,
              style: TextStyle(
                  fontSize: 30,
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
          Container(
            width: 60,
            height: 60,
            child: FutureBuilder(
              future: orderList,
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
                return CupertinoButton(
                    padding:
                        EdgeInsets.only(top: 10, left: 0, bottom: 0, right: 10),
                    minSize: 50,
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Stack(
                            fit: StackFit.expand,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                              Positioned(
                                left: 20,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),
                                  child: snapshot.data!.isNotEmpty
                                      ? Center(
                                          child: Text(
                                            snapshot.data!.length.toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            '0',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                ),
                              )
                            ]),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            OrderScreen(userModel: widget.usermodel),
                      ));
                    });
              },
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(
                          File(widget.productModel.imgpath!),
                        ),
                        fit: BoxFit.contain),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.productModel.name!,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.productModel.price! + "\$",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 100,
                child: Text(
                  widget.productModel.description!,
                  maxLines: 5,
                  style:
                      TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis),
                ),
              ),
              Container(
                height: 70,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Icon(
                        Icons.location_on,
                        size: 40,
                      ),
                      Text('Address')
                    ]),
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.arrow_forward_ios))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  height: 50,
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                        future: orderList,
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Container(
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xFFDB9E00)),
                            child: TextButton(
                                onPressed: () async {
                                  bool add = true;
                                  for (var order in snapshot.data!) {
                                    if (order.productId ==
                                            widget.productModel.id &&
                                        order.payment == '0') {
                                      add = false;
                                    }
                                  }
                                  add == true
                                      ? await OrderDatabaseHelper()
                                          .insertData(OrderModel(
                                          orderid: DateTime.now().microsecond,
                                          userId: widget.usermodel.id,
                                          orderQty: 1,
                                          payment: "0",
                                          productId: widget.productModel.id,
                                          total: widget.productModel.price,
                                        ))
                                      : showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                title: Text(
                                                    'Product Already In Cart'),
                                                content: Text(
                                                    'This Product Is Already in Cart'));
                                          },
                                        );
                                  ;
                                  getRefresh();
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                ),
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(color: Colors.black),
                                )),
                          );
                        },
                      ),
                      Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xFFDB9E00)),
                        child: TextButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                            ),
                            child: Text(
                              "Buy Now",
                              style: TextStyle(color: Colors.black),
                            )),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Similar Products",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildProductList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Container(
      child: FutureBuilder(
        future: productList,
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
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
          List<ProductModel> productListFilter = [];
          for (var product in snapshot.data!) {
            if (product.category!
                .toLowerCase()
                .contains(widget.productModel.category!.toLowerCase())) {
              productListFilter.add(product);
            }
            ;
          }
          return Container(
            height: 300,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: productListFilter.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (200 / 150),
                crossAxisCount: 1,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (context, index) {
                var product = productListFilter[index];
                return CupertinoButton(
                  padding: EdgeInsets.all(5),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BuyProductScreen(
                        productModel: product,
                        usermodel: widget.usermodel,
                      ),
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(5),
                    width: 300,
                    height: 300,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 100,
                            child: Image(
                              image: FileImage(
                                File(product.imgpath!),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            product.name!,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            softWrap: true,
                            maxLines: 2,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 130,
                                child: Text(
                                  product.description!,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                product.category!,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 64, 64, 64)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                product.price! + "\$",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
