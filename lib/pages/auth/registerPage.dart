import 'package:flutter/material.dart';
import 'package:personalmoney/l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // final AuthService authService = AuthService();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.btnRegister),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController, 
              decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder())
            ),
            const SizedBox(height: 15.0),
            TextField(
              controller: emailController, 
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email, border: OutlineInputBorder())
            ),
            const SizedBox(height: 15.0),
            TextField(
              controller: passwordController, 
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.password, border: OutlineInputBorder()), 
              obscureText: true
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed:() {},
              icon: Icon(Icons.save_alt), 
              label: Text(AppLocalizations.of(context)!.btnSaveChanges)
            ),
          ],
        ),
      ),
    );
  }
}