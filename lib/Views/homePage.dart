import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/Views/buyProductPage.dart';
import 'package:shop/Views/categoryListPage.dart';
import 'package:shop/Views/loginPage.dart';
import 'package:shop/Views/orderPage.dart';
import 'package:shop/Views/productListPage.dart';
import 'package:shop/Views/userListPage.dart';
import 'package:shop/database/CategoryDBHelper.dart';
import 'package:shop/database/ProductDBHelper.dart';
import 'package:shop/database/UserDBHelper.dart';
import 'package:shop/database/orderDBHelper.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/models/order_Model.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/models/user_model.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.usermodel});

  UserModel usermodel;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<CategoryModel>>? categoryList;
  Future<List<UserModel>>? userList;
  Future<List<ProductModel>>? productList;
  Future<List<OrderModel>>? orderList;

  late CategoryDatabaseHelper catdb;
  late UserDatabaseHelper userdb;
  late ProductDatabaseHelper productdb;
  late OrderDatabaseHelper orderdb;

  getrefresh() {
    catdb = CategoryDatabaseHelper();
    userdb = UserDatabaseHelper();
    productdb = ProductDatabaseHelper();
    orderdb = OrderDatabaseHelper();

    setState(() {
      categoryList = catdb.getUserData();
      userList = userdb.getUserData();
      productList = productdb.getProductData();
      orderList = orderdb.GetUnpaidProductByUserId(widget.usermodel.id!);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getrefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "neo",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "shop",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDB9E00)),
                      )
                    ],
                  ),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return CupertinoButton(
                            padding: EdgeInsets.zero,
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
                                                    snapshot.data!.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              : Center(
                                                  child: Text(
                                                    '0',
                                                    style: TextStyle(
                                                        color: Colors.white),
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
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search for products',
                    prefixIcon: Icon(Icons.search)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 120,
                decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(20)),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'see all',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _buildCategoryList(),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              _buildProductList(),
            ],
          ),
        ),
      ),
    );
  }

  //* Build Porduct List

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
          return Container(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (300 / 450),
                crossAxisCount: 2,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (context, index) {
                var product = snapshot.data![index];
                return CupertinoButton(
                  padding: EdgeInsets.all(5),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BuyProductScreen(
                        usermodel: widget.usermodel,
                        productModel: product,
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

  Widget _buildCategoryList() {
    return Container(
      height: 250,
      child: FutureBuilder(
        future: categoryList,
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoryModel>> snapshot) {
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
          return GridView.builder(
            shrinkWrap: true,
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (150 / 100),
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5),
            itemBuilder: (context, index) {
              var category = snapshot.data![index];
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      child: Image(
                        image: FileImage(File(category.imgpath!)),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(category.name!)
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              height: 200,
              child: FutureBuilder(
                future: userList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<UserModel>> snapshot) {
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
                  for (UserModel user in snapshot.data!) {
                    if (user.id == widget.usermodel.id) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Color(0xFFDB9E00),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                image: user.imgpath != null
                                    ? DecorationImage(
                                        image: FileImage(File(user.imgpath!)))
                                    : null,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              user.name!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text(user.email!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                )),
                          ],
                        ),
                      );
                    }
                  }
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Color(0xFFDB9E00),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          'Name',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text('Email',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserListScreen(),
                  ));
                },
                title: Text('Users'),
                leading: Icon(
                  Icons.person,
                  color: Color(0xFF4f4f4f),
                ),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategoryListScreen(),
                  ));
                },
                title: Text('Categories'),
                leading: Icon(Icons.category, color: Color(0xFF4f4f4f)),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductListScreen(),
                  ));
                },
                title: Text('Products'),
                leading: Icon(Icons.shopping_cart, color: Color(0xFF4f4f4f)),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        OrderScreen(userModel: widget.usermodel),
                  ));
                },
                title: Text('Orders'),
                leading: Icon(Icons.sell, color: Color(0xFF4f4f4f)),
              ),
            ),
            Card(
              child: ListTile(
                onTap: getrefresh,
                title: Text('Refresh'),
                leading: Icon(Icons.refresh, color: Color(0xFF4f4f4f)),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => loginPage()));
                },
                title: Text('Log Out'),
                leading: Icon(Icons.exit_to_app, color: Color(0xFF4f4f4f)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
