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
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        // iconTheme: IconThemeData(color: Colors.white)
      ),
      home: HomePage()
    );
  }
}