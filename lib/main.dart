import 'package:adminapp/admin/admin.dart';
import 'package:flutter/material.dart';

import 'loginpage.dart';
import 'dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.green
    ),
    home: LoginPage(),
    );
  }
}
