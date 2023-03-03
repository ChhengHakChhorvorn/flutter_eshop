import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/Views/homePage.dart';
import 'package:shop/Views/signUpPage.dart';
import 'package:shop/database/UserDBHelper.dart';
import 'package:shop/models/user_model.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  Future<List<UserModel>>? userList;

  TextEditingController _txtEmail = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();

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
      body: FutureBuilder(
        future: userList,
        builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
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
          return _buildBody(context, snapshot);
        },
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 100, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "neo",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
          SizedBox(
            height: 10,
          ),
          Text('Login',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextField(
            controller: _txtEmail,
            decoration: InputDecoration(
                hintText: 'Email', border: OutlineInputBorder()),
          ),
          TextField(
            controller: _txtPassword,
            decoration: InputDecoration(
                hintText: 'Password', border: OutlineInputBorder()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(color: Color(0xFF4f4f4f)),
                  ))
            ],
          ),
          SizedBox(
            width: 400,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                bool access = false;
                for (var user in snapshot.data!) {
                  if (user.email!.toLowerCase() ==
                          _txtEmail.text.toLowerCase() &&
                      user.password!.toLowerCase() ==
                          _txtPassword.text.toLowerCase()) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HomePage(usermodel: user),
                    ));
                    access = true;
                  }
                }
                if (access == false) {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Text('Incorrect Email or Password'),
                          content: Text(
                              'Please eneter the Correct Email or password'));
                    },
                  );
                }
              },
              child: Text(
                'Login',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color(0xFF4f4f4f),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'or continue with',
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF4f4f4f), width: 0.5),
                ),
                child: Center(
                  child: Image.network(
                    'https://www.freepnglogos.com/uploads/apple-logo-png/apple-logo-png-dallas-shootings-don-add-are-speech-zones-used-4.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF4f4f4f), width: 0.5),
                ),
                child: Center(
                  child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/1024px-Facebook_Logo_%282019%29.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF4f4f4f), width: 0.5),
                ),
                child: Center(
                  child: Image.network(
                    'https://companieslogo.com/img/orig/GOOG-0ed88f7c.png?t=1633218227',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(color: Color(0xFFc1c1c1)),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => signUpPage(),
                    ));
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Color(0xFF4f4f4f),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
