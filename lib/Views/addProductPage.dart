import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/database/CategoryDBHelper.dart';
import 'package:shop/database/ProductDBHelper.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/models/user_model.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({super.key, required this.productModel});

  ProductModel productModel;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController txtProductName = TextEditingController();
  TextEditingController txtProductPrice = TextEditingController();

  TextEditingController txtProductQty = TextEditingController();

  TextEditingController txtProductDescription = TextEditingController();

  String dropdownValue = '';
  Future<List<CategoryModel>>? categoryList;
  late CategoryDatabaseHelper categorydb;

  File? _image;

  Future getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    File tempimg = File(image.path);

    setState(() {
      _image = tempimg;
    });
  }

  getRefresh() {
    categorydb = CategoryDatabaseHelper();

    setState(() {
      categoryList = categorydb.getUserData();
    });
  }

  @override
  void initState() {
    super.initState();
    getRefresh();

    widget.productModel.name != null
        ? txtProductName.text = widget.productModel.name!
        : '';
    widget.productModel.price != null
        ? txtProductPrice.text = widget.productModel.price!
        : '';
    widget.productModel.qty != null
        ? txtProductQty.text = widget.productModel.qty!
        : '';
    widget.productModel.description != null
        ? txtProductDescription.text = widget.productModel.description!
        : '';

    widget.productModel.category != null
        ? dropdownValue = widget.productModel.category!
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: widget.productModel.id == null
              ? [
                  Text(
                    "add",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    "product",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDB9E00)),
                  )
                ]
              : [
                  Container(
                    width: 200,
                    child: Text(
                      widget.productModel.name!,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDB9E00),
                      ),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
        actions: widget.productModel.id != null
            ? [
                IconButton(
                    onPressed: () async {
                      await ProductDatabaseHelper()
                          .deleteData(widget.productModel.id!);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Color(0xff4f4f4f),
                    )),
                IconButton(
                    onPressed: getImageFromGallery,
                    icon: Icon(
                      Icons.image,
                      color: Color(0xff4f4f4f),
                    ))
              ]
            : [
                IconButton(
                    onPressed: getImageFromGallery,
                    icon: Icon(
                      Icons.image,
                      color: Color(0xff4f4f4f),
                    ))
              ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                color: Colors.pink,
                child: _image != null
                    ? Image(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      )
                    : widget.productModel.imgpath != null
                        ? Image(
                            image:
                                FileImage(File(widget.productModel.imgpath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
              ),
              SizedBox(height: 20),
              TextField(
                controller: txtProductName,
                decoration: InputDecoration(
                    hintText: 'Product Name', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              FutureBuilder(
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
                  List<String>? items = [];

                  for (var category in snapshot.data!) {
                    if (category.name != null) {
                      items.add(category.name!);
                    }
                  }

                  return Container(
                    padding: EdgeInsets.all(5),
                    width: 350,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      itemHeight: 50,
                      value: dropdownValue == '' ? null : dropdownValue,
                      items: items.map((item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    )),
                  );
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: txtProductPrice,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Product Price', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextField(
                controller: txtProductQty,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Quantity', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextField(
                controller: txtProductDescription,
                decoration: InputDecoration(
                    hintText: 'Description', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              Container(
                width: 350,
                height: 50,
                child: widget.productModel.id != null
                    ? ElevatedButton(
                        onPressed: () async {
                          await ProductDatabaseHelper()
                              .updateData(ProductModel(
                                  id: widget.productModel.id,
                                  category: dropdownValue,
                                  price: txtProductPrice.text,
                                  description: txtProductDescription.text,
                                  name: txtProductName.text,
                                  qty: txtProductQty.text,
                                  imgpath: _image != null
                                      ? _image!.path
                                      : widget.productModel.imgpath))
                              .whenComplete(() {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text(
                          'Update',
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 0, backgroundColor: Color(0xFF4f4f4f)),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          await ProductDatabaseHelper()
                              .insertData(ProductModel(
                                  id: DateTime.now().microsecond,
                                  category: dropdownValue,
                                  price: txtProductPrice.text,
                                  description: txtProductDescription.text,
                                  name: txtProductName.text,
                                  qty: txtProductQty.text,
                                  imgpath: _image!.path))
                              .whenComplete(() {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 0, backgroundColor: Color(0xFF4f4f4f)),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
