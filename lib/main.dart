import 'package:flutter/material.dart';
import 'package:personalmoney/pages/homepage.dart';

void main() => runApp(const PersonalMoney());

class PersonalMoney extends StatelessWidget {
  const PersonalMoney({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Money',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      // initialRoute: '/login',
      initialRoute: '/home',
      routes: {
        // '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}