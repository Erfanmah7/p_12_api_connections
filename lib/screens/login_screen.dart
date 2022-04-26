import 'package:flutter/material.dart';
import 'package:p_12_api_connections/constants.dart';
import 'package:p_12_api_connections/function.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController userController;
  late TextEditingController passController;

  @override
  void initState() {
    userController = TextEditingController();
    passController = TextEditingController();
    checkToken();
    super.initState();
  }

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: userController,
                decoration: kTextfeild.copyWith(hintText: 'Username'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: kTextfeild.copyWith(hintText: 'Password'),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 400,
                child: ElevatedButton(
                  onPressed: login,
                  child: Text('Login'),
                ),
              ),
              TextButton(
                onPressed: () {
                  kNavigat(context,'signup','-1',-1);
                },
                child: Text('Go to SignUp'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    String username = userController.text;
    String password = passController.text;

    if (username.length == 0 || password.length == 0) {
      return print('please enter name');
    }

    http.Response response = await http.post(
      //send json data
      Uri.parse('$kApi/api/login/'),
      body: convert.json.encode({
        'username': username,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    print(response.statusCode);
    print(response.body);

    //get json data
    Map resMap = convert.json.decode(response.body);
    //تمام اطلاعات به همراه کلیدهایشان در بک اند
    List res = await kSavelocal(resMap,'user_name');
    if (res.length != 0) {
      kNavigat(context,'home',res[0],res[1]);
    }
  }

  void checkToken() async {
    SharedPreferences prf = await SharedPreferences.getInstance();

    if (prf.containsKey('token')) {
      String token = prf.getString('token') ?? '-1';
      int userId = prf.getInt('id') ?? -1;
      kNavigat(context,'home',token,userId);
    }
  }
}
