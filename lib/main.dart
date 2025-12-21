import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:personalmoney/helpers/AuthWrapper.dart';
import 'package:personalmoney/helpers/theme/appColorsTheme.dart';
import 'package:personalmoney/helpers/theme/appTextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

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
              title: 'Personal Money - Expense Tracker',
              locale: currentLocale,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
                textTheme: AppTextTheme.lightTextTheme,
                appBarTheme: AppBarTheme(
                  elevation: 2,
                  scrolledUnderElevation: 4,
                  centerTitle: true,
                  backgroundColor: AppColors.primary, //Color(0xFFF78c2ad),
                  foregroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.white),
                ),
              ),
              darkTheme: ThemeData.dark().copyWith(
                textTheme: AppTextTheme.darkTextTheme,
                appBarTheme: const AppBarTheme(
                  elevation: 2,
                  scrolledUnderElevation: 4,
                  centerTitle: true,
                  backgroundColor: AppColors.primary, //Color(0xFFF78c2ad),
                  foregroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.white),
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
                //TODO: Agregar idiomas para los paises(Alemania, Italia)
              ],
              home: AuthWrapper() //LoginPage(),
            );
          },
        );
      },
    );
  }

}