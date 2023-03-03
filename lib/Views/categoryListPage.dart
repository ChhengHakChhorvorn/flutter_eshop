import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/Views/addCategoryPage.dart';
import 'package:shop/database/CategoryDBHelper.dart';
import 'package:shop/models/category_model.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  Future<List<CategoryModel>>? categoryList;

  late CategoryDatabaseHelper db;

  getRefresh() {
    db = CategoryDatabaseHelper();

    setState(() {
      categoryList = db.getUserData();
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
              "Categories",
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
          return Container(
            padding: EdgeInsets.all(20),
            child: GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                var category = snapshot.data![index];
                return CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          AddCategoryScreen(categoryModel: category),
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
                                File(category.imgpath!),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            category.name!,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
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
          CategoryModel categoryModel = CategoryModel();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                AddCategoryScreen(categoryModel: categoryModel),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
