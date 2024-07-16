import 'package:flutter/material.dart';
import 'package:personalmoney/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const PersonalMoney());
}

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
        // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(secondary: Colors.red.shade300),
      ),
      home: HomePage()
    );
  }
}