import 'package:flutter/material.dart';
import 'package:personalmoney/pages/auth/loginPage.dart';
import 'package:personalmoney/pages/home_page.dart';
import 'package:personalmoney/services/authService.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return HomePage();
        }

        return LoginPage();
      },
    );
  }
}
// class AuthWrapper extends StatefulWidget {
//   @override
//   State<AuthWrapper> createState() => _AuthWrapperState();
// }

// class _AuthWrapperState extends State<AuthWrapper> {
//   String? token;
//   bool loading = true;

//   @override
//   void initState() {
//     super.initState();

//     _checkAuth();
//   }

//   Future<void> _checkAuth() async {
//     final savedToken = await AuthService.getToken();
    
//     if (!mounted) {
//       return;
//     }

//     setState(() {
//       token = savedToken;
//       loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
    
//     return token == null ? LoginPage() : HomePage();
//   }
// }