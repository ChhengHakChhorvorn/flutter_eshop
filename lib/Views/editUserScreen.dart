import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/database/UserDBHelper.dart';
import 'package:shop/models/user_model.dart';

class editUserScreen extends StatefulWidget {
  editUserScreen({super.key, required this.userModel});

  UserModel userModel;

  @override
  State<editUserScreen> createState() => _editUserScreenState();
}

class _editUserScreenState extends State<editUserScreen> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
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
    widget.userModel.name != null
        ? txtName.text = widget.userModel.name!
        : txtName.text = '';

    widget.userModel.email != null
        ? txtEmail.text = widget.userModel.email!
        : txtEmail.text = '';

    widget.userModel.password != null
        ? txtPassword.text = widget.userModel.password!
        : txtPassword.text = '';
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
              widget.userModel.name!,
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
          IconButton(
              onPressed: getImageFromGallery,
              icon: Icon(
                Icons.photo_library,
                color: Colors.black,
              ))
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  child: _image != null
                      ? Image(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        )
                      : widget.userModel.imgpath != null
                          ? Image(
                              image: FileImage(File(widget.userModel.imgpath!)))
                          : Center(child: Icon(Icons.warning)),
                ),
              ),
              TextField(
                controller: txtName,
                decoration: InputDecoration(
                    hintText: 'Name', border: OutlineInputBorder()),
              ),
              TextField(
                controller: txtEmail,
                decoration: InputDecoration(
                    hintText: 'Email', border: OutlineInputBorder()),
              ),
              TextField(
                controller: txtPassword,
                decoration: InputDecoration(
                    hintText: 'Password', border: OutlineInputBorder()),
              ),
              Container(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await UserDatabaseHelper().updateData(UserModel(
                        id: widget.userModel.id,
                        email: txtEmail.text,
                        name: txtName.text,
                        password: txtPassword.text,
                        imgpath: _image != null
                            ? _image!.path
                            : widget.userModel.imgpath));
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
          )),
    );
  }
}
