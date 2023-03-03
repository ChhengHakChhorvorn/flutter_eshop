import 'package:flutter/material.dart';
import 'package:shop/Views/loginPage.dart';
import 'package:shop/database/UserDBHelper.dart';
import 'package:shop/models/user_model.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  Future<List<UserModel>>? userList;

  TextEditingController _txtEmail = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();
  TextEditingController _txtName = TextEditingController();
  late UserDatabaseHelper db;

  void getRefresh() {
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
          return _buildBody(context, snapshot);
        },
      ),
    );
    ;
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
          Text(
            'Sign Up',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _txtName,
            decoration:
                InputDecoration(hintText: 'Name', border: OutlineInputBorder()),
          ),
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
          SizedBox(
            width: 400,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                for (var user in snapshot.data!) {
                  if (user.email!.toLowerCase() ==
                      _txtEmail.text.toLowerCase()) {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: Text('Email In Use'),
                            content: Text('This Email has already used'));
                      },
                    );
                  }
                }

                if (_txtEmail.text == '' ||
                    _txtPassword.text == '' ||
                    _txtName.text == '') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Text('Missing Information'),
                          content: Text('Email Or Password Is Null'));
                    },
                  );
                } else {
                  await UserDatabaseHelper()
                      .insertData(UserModel(
                          id: DateTime.now().microsecond,
                          name: _txtName.text,
                          email: _txtEmail.text,
                          password: _txtPassword.text))
                      .then((value) => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => loginPage(),
                          )));
                }
              },
              child: Text(
                'Sign Up',
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
                "Already have an account?",
                style: TextStyle(color: Color(0xFFc1c1c1)),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => loginPage(),
                    ));
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Login',
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
