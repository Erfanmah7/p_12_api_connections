import 'package:flutter/material.dart';
import 'package:p_12_api_connections/screens/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/homescreen.dart';
import 'screens/login_screen.dart';

Future<List> kSavelocal(Map map, String type) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = 'token ${map['token']}';
    await pref.setInt('id', map['id']);
    await pref.setString('username', map[type]);
    await pref.setString(
        'fullname', '${map['first_name']} ${map['last_name']}');
    await pref.setString('token', token);
    return [token, map['id']];
  } catch (e) {
    print(e);
    return [];
  }
}

kNavigat(BuildContext context, String type, String token, userId) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) {
        if (type == 'home') {
          return HomeScreen(
            token: token,
            userId: userId,
          );
        } else if (type == 'login') {
          return Login();
        } else {
          return SignUp();
        }
      },
    ),
  );
}

Future<bool> kSignOut() async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.clear();
  } catch (e) {
    print(e);
    return false;
  }
}
