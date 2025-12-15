import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:personalmoney/pages/auth/loginPage.dart';
import 'package:personalmoney/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('themeMode') ?? 'system';
  final savedLang = prefs.getString('language');
  
  Locale? initialLocale;
  ThemeMode initialTheme;

  switch (savedTheme) {
    case 'light':
      initialTheme = ThemeMode.light;
      break;
    case 'dark':
      initialTheme = ThemeMode.dark;
      break;
    default:
      initialTheme = ThemeMode.system;
  }

  if (savedLang != null) {
    initialLocale = Locale(savedLang);
  }

  runApp(PersonalMoney(initialTheme: initialTheme, initialLocale: initialLocale,));
}

class PersonalMoney extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);
  static final ValueNotifier<Locale?> localeNotifier = ValueNotifier(null);

  final ThemeMode initialTheme;
  final Locale? initialLocale;

  PersonalMoney({required this.initialTheme, this.initialLocale}) {
    themeNotifier.value = initialTheme;
    localeNotifier.value = initialLocale;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: localeNotifier,
      builder: (_, Locale? currentLocale, __) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, ThemeMode currentMode, __) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Personal Money',
              locale: currentLocale,
              theme: ThemeData(
                useMaterial3: false,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
                // textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
                appBarTheme: AppBarTheme(
                  // elevation: 2,
                  centerTitle: false,
                  scrolledUnderElevation: 6,
                  backgroundColor: Colors.teal,
                  // backgroundColor: Color(0xFFF78c2ad), //New Color in the update,
                  foregroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                cardTheme: CardThemeData(
                  elevation: 2
                )
              ),
              darkTheme: ThemeData.dark().copyWith(
                useMaterial3: false,
                appBarTheme: const AppBarTheme(
                  foregroundColor: Colors.white,
                  // elevation: 2,
                  centerTitle: false,
                  scrolledUnderElevation: 6,
                ),
              ),
              themeMode: currentMode,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('es'),
                Locale('pt'),
                Locale('fr'),
                //TODO: Agregar idiomas para los paises(Alemania, Haiti, Italia)
              ],
              home: HomePage(),
              // home: LoginPage(),
            );
          },
        );
      },
    );
  }

}