import 'package:flutter/material.dart';
import 'package:p_12_api_connections/constants.dart';
import 'package:p_12_api_connections/function.dart';
import 'package:p_12_api_connections/screens/homescreen.dart';
import 'package:p_12_api_connections/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController firstController;
  late TextEditingController lastController;
  late TextEditingController emailController;
  late TextEditingController userController;
  late TextEditingController passController;

  @override
  void initState() {
    firstController = TextEditingController();
    lastController = TextEditingController();
    emailController = TextEditingController();
    userController = TextEditingController();
    passController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    firstController.dispose();
    lastController.dispose();
    emailController.dispose();
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
                controller: firstController,
                decoration: kTextfeild.copyWith(hintText: 'First name'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: lastController,
                decoration: kTextfeild.copyWith(hintText: 'Last name'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailController,
                decoration: kTextfeild.copyWith(hintText: 'Email'),
              ),
              SizedBox(
                height: 20,
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
                  onPressed: signup,
                  child: Text('SignUp'),
                ),
              ),
              TextButton(
                onPressed: () {
                  kNavigat(context,'login','-1',-1);
                },
                child: Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signup() async {
    String firstname = firstController.text;
    String lastname = lastController.text;
    String email = emailController.text;
    String username = userController.text;
    String password = passController.text;

    http.Response response = await http.post(
      //send json data
      Uri.parse('$kApi/api/register/'),
      body: convert.json.encode({
        'first_name': firstname,
        'last_name': lastname,
        'email': email,
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
    List res = await kSavelocal(resMap,'username');
    if (res.length != 0) {
      kNavigat(context,'home',res[0],res[1]);
    }
  }



}
