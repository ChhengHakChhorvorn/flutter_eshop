import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/Views/addProductPage.dart';
import 'package:shop/database/ProductDBHelper.dart';
import 'package:shop/models/product_model.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  Future<List<ProductModel>>? productList;
  File? _image;

  late ProductDatabaseHelper productdb;

  getrefresh() {
    productdb = ProductDatabaseHelper();

    setState(() {
      productList = productdb.getProductData();
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
                "Products",
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
        ),
        body: FutureBuilder(
          future: productList,
          builder: (BuildContext context,
              AsyncSnapshot<List<ProductModel>> snapshot) {
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
            return Container(
              padding: EdgeInsets.all(20),
              child: GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: (300 / 400),
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemBuilder: (context, index) {
                  var product = snapshot.data![index];
                  return CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddProductScreen(productModel: product),
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
                                )
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
                            )
                          ]),
                    ),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ProductModel productModel = ProductModel();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  AddProductScreen(productModel: productModel),
            ));
          },
          child: Icon(Icons.add),
        ));
  }
}
