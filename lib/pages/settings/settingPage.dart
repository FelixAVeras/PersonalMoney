import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personalmoney/helpers/theme/appColorsTheme.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _saveThemePreference(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String themeString;

    switch (mode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      default:
        themeString = 'system';
    }

    await prefs.setString('themeMode', themeString);
    
    PersonalMoney.themeNotifier.value = mode;
  }

  Future<void> _saveLanguagePreference(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);
    PersonalMoney.localeNotifier.value = Locale(langCode);
  }

  bool notificationSwitch = false;
  bool biometricSwitch = false;
  bool userProSwitch = false;

  @override
  Widget build(BuildContext context) {
    bool syncEnabled = false;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
      ? Colors.grey.shade200
      : const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
        ),
      ),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: PersonalMoney.themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Card.outlined(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.appTheme, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text(AppLocalizations.of(context)!.system),
                      value: ThemeMode.system,
                      groupValue: currentMode,
                      onChanged: (mode) {
                        if (mode != null) _saveThemePreference(mode);
                      },
                      activeColor: Color(0xFFF3969A),
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text(AppLocalizations.of(context)!.light),
                      value: ThemeMode.light,
                      groupValue: currentMode,
                      onChanged: (mode) {
                        if (mode != null) _saveThemePreference(mode);
                      },
                      activeColor: Color(0xFFF3969A),
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text(AppLocalizations.of(context)!.dark),
                      value: ThemeMode.dark,
                      groupValue: currentMode,
                      onChanged: (mode) {
                        if (mode != null) _saveThemePreference(mode);
                      },
                      activeColor: Color(0xFFF3969A),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Card.outlined(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.language, style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                    // Idioma del sistema
                    RadioListTile<String>(
                      title: Text(AppLocalizations.of(context)!.system),
                      value: "system",
                      groupValue: PersonalMoney.localeNotifier.value?.languageCode ?? "system",
                      onChanged: (value) async {
                        if (value == "system") {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove("language");

                          /// Null = usar idioma del sistema
                          PersonalMoney.localeNotifier.value = null;
                        }
                      },
                      activeColor: Color(0xFFF3969A),
                    ),
                    // Español
                    RadioListTile<String>(
                      title: Text("Español"),
                      value: "es",
                      groupValue: PersonalMoney.localeNotifier.value?.languageCode ?? "system",
                      onChanged: (value) {
                        if (value != null) {
                          _saveLanguagePreference(value);
                        }
                      },
                      activeColor: Color(0xFFF3969A),
                    ),
                    // Inglés
                    RadioListTile<String>(
                      title: Text("English"),
                      value: "en",
                      groupValue: PersonalMoney.localeNotifier.value?.languageCode ?? "system",
                      onChanged: (value) {
                        if (value != null) {
                          _saveLanguagePreference(value);
                        }
                      },
                      activeColor: Color(0xFFF3969A),
                    ),

                    // Portugués
                    RadioListTile<String>(
                      title: Text("Português"),
                      value: "pt",
                      groupValue: PersonalMoney.localeNotifier.value?.languageCode ?? "system",
                      onChanged: (value) {
                        if (value != null) {
                          _saveLanguagePreference(value);
                        }
                      },
                      activeColor: Color(0xFFF3969A),
                    ),

                    // Francés
                    RadioListTile<String>(
                      title: Text("Français"),
                      value: "fr",
                      groupValue: PersonalMoney.localeNotifier.value?.languageCode ?? "system",
                      onChanged: (value) {
                        if (value != null) {
                          _saveLanguagePreference(value);
                        }
                      },
                      activeColor: Color(0xFFF3969A),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 12),
              // Card.outlined(
              //   child: Column(
              //     children: [
              //       ListTile(
              //         leading: Icon(Icons.attach_money),
              //         title: Text('Tipos de Moneda', style: const TextStyle(fontWeight: FontWeight.bold)),
              //         subtitle: Text('Establecer cambios de monedas'),
              //         trailing: Icon(Icons.arrow_forward_rounded),
              //         onTap: () {},
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 12),
              Card.outlined(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Sincronizacion de datos',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    SwitchListTile(
                      title: Text(
                        'Subir datos a nube',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'Sincroniza automáticamente las datos guardados en tu dispositivo',
                        style: GoogleFonts.quicksand(fontWeight: FontWeight.w400),
                      ),
                      secondary: Icon(Icons.cloud_upload),
                      value: syncEnabled,
                      onChanged: (value) async {
                        syncEnabled = value;

                        // Aquí guardas la preferencia local
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('syncEnabled', value);

                        if (value) {
                          // ------------------------------------
                          // 🔄 LÓGICA DE SINCRONIZACIÓN
                          // ------------------------------------
                          // 1. Leer datos de la base de datos local
                          // 2. Enviar datos al API
                          // 3. Manejar errores
                          // 4. Confirmar sincronización
                          //
                          // Ejemplo (pseudo):
                          //
                          // final localData = await db.getAllLists();
                          // await api.uploadLists(localData);
                          // ------------------------------------
                        }

                        // Si usas StatefulWidget:
                        // setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Card.outlined(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.securityPrivacy, style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                    SwitchListTile(
                      value: notificationSwitch, 
                      onChanged: (bool value) {
                        setState(() => notificationSwitch = value);
                      },
                      activeColor: Color(0xFFF3969A),
                      secondary: Icon(Icons.notifications),
                      title: Text('Notificaciones')
                    ),
                    SwitchListTile(
                      value: biometricSwitch, 
                      secondary: Icon(Icons.fingerprint),
                      onChanged: (bool value) {
                        setState(() => biometricSwitch = value);
                      },
                      activeColor: Color(0xFFF3969A),
                      title: Text('Datos Biometricos')
                    ),
                    SwitchListTile(
                      value: userProSwitch, 
                      secondary: Image.asset('assets/pigbank.png', width: 32.0),
                      onChanged: (bool value) {
                        setState(() => userProSwitch = value);
                      },
                      activeColor: Color(0xFFF3969A),
                      title: Text('PersonalMoney PRO', style: TextStyle(color: AppColors.info, fontWeight: FontWeight.bold))
                    ),
                    // SizedBox(height: 10),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.person_off, color: Colors.red),
                      title: Text('Eliminar Cuenta', style: TextStyle(color: Colors.red)),
                      onTap: () {},
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}