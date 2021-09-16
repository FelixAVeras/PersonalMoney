import 'package:flutter/material.dart';
import 'package:personalmoney/bloc/provider.dart';
// import 'package:personalmoney/bloc/register_provider.dart';
import 'package:personalmoney/pages/homepage.dart';
import 'package:personalmoney/pages/loginpage.dart';
import 'package:personalmoney/pages/registerpage.dart';

import 'package:personalmoney/helpers/databasehelper.dart';
// void main() => runApp(PersonalMoney());

void main() async {
  await DbConn;
  runApp(PersonalMoney());
}

class PersonalMoney extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomProvider(
        child: MaterialApp(
      title: 'Personal Money',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      initialRoute: 'Home',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
        'Home': (BuildContext context) => HomePage(),
      },
    ));
  }
}
