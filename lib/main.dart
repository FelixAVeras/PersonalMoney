import 'package:flutter/material.dart';
import 'package:personalmoney/pages/auth/loginPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

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
        appBarTheme: AppBarTheme(
          elevation: 2,
          centerTitle: false,
          scrolledUnderElevation: 4,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
        // Locale('pr'), // Portuguese
        // Locale('fr'), // French
      ],
      home: LoginPage() //HomePage()
    );
  }
}