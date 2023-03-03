import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/database/CategoryDBHelper.dart';
import 'package:shop/models/category_model.dart';

class AddCategoryScreen extends StatefulWidget {
  AddCategoryScreen({super.key, required this.categoryModel});
  CategoryModel categoryModel;

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController txtCategoryName = TextEditingController();
  TextEditingController txtCategoryDesc = TextEditingController();
  File? _image;

  Future getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    File tempimg = File(image.path);

    setState(() {
      _image = tempimg;
    });
  }

  @override
  void initState() {
    super.initState();

    widget.categoryModel.name != null
        ? txtCategoryName.text = widget.categoryModel.name!
        : txtCategoryName.text = '';

    widget.categoryModel.description != null
        ? txtCategoryDesc.text = widget.categoryModel.description!
        : txtCategoryDesc.text = '';
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
              "neo",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: widget.categoryModel.id != null
            ? [
                IconButton(
                    onPressed: () async {
                      await CategoryDatabaseHelper()
                          .deleteData(widget.categoryModel.id!)
                          .whenComplete(() {
                        Navigator.of(context).pop();
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: getImageFromGallery,
                    icon: Icon(
                      Icons.photo_library,
                      color: Colors.black,
                    ))
              ]
            : [
                IconButton(
                    onPressed: getImageFromGallery,
                    icon: Icon(
                      Icons.photo_library,
                      color: Colors.black,
                    ))
              ],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 300,
              height: 300,
              child: _image != null
                  ? Image(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    )
                  : widget.categoryModel.imgpath != null
                      ? Image(
                          image: FileImage(File(widget.categoryModel.imgpath!)))
                      : Center(child: Icon(Icons.warning)),
            ),
            TextField(
              controller: txtCategoryName,
              decoration: InputDecoration(
                  hintText: 'Category Name', border: OutlineInputBorder()),
            ),
            TextField(
              controller: txtCategoryDesc,
              decoration: InputDecoration(
                  hintText: 'Description', border: OutlineInputBorder()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 350,
                  height: 50,
                  child: widget.categoryModel.id == null
                      ? ElevatedButton(
                          onPressed: () async {
                            await CategoryDatabaseHelper()
                                .insertData(CategoryModel(
                                    id: DateTime.now().microsecond,
                                    name: txtCategoryName.text,
                                    description: txtCategoryDesc.text,
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
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            await CategoryDatabaseHelper()
                                .updateData(CategoryModel(
                                    id: widget.categoryModel.id,
                                    name: txtCategoryName.text,
                                    description: txtCategoryDesc.text,
                                    imgpath: _image!.path))
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
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
