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
              decoration: InputDecoration(labelText: 'Full Name')
            ),
            const SizedBox(height: 15.0),
            TextField(
              controller: emailController, 
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email)
            ),
            const SizedBox(height: 15.0),
            TextField(
              controller: passwordController, 
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.password), 
              obscureText: true
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed:() {},
              style: ElevatedButton.styleFrom(
                // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 95),
                backgroundColor: Color(0xFFF78c2ad),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))
              ),
              icon: Icon(Icons.save_alt, color: Colors.white), 
              label: Text(
                AppLocalizations.of(context)!.btnSaveChanges, 
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}