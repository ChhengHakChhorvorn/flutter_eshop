import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop/Views/editUserScreen.dart';
import 'package:shop/database/UserDBHelper.dart';
import 'package:shop/models/user_model.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  Future<List<UserModel>>? userList;

  late UserDatabaseHelper db;

  getRefresh() {
    db = UserDatabaseHelper();

    setState(() {
      userList = db.getUserData();
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
              "Users",
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
        future: userList,
        builder:
            (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
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
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var user = snapshot.data![index];
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => editUserScreen(userModel: user),
                    ));
                  },
                  leading: CircleAvatar(
                      backgroundImage: user.imgpath != null
                          ? FileImage(File(user.imgpath!))
                          : null),
                  title: Text(user.name!),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await UserDatabaseHelper()
                          .deleteData(user.id!)
                          .whenComplete(() => getRefresh());
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
