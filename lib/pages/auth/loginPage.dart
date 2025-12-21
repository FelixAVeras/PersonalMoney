import 'package:flutter/material.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/pages/auth/registerPage.dart';
import 'package:personalmoney/pages/home_page.dart';
import 'package:personalmoney/services/authService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  
  bool hidePassword = true;
  bool isRemember = false;
  bool rememberUsername = false;
  bool isLoading = false;

  String? loginError = '';

  static const String kRememberUsernameKey = 'remember_username';
  static const String kSavedEmailKey = 'saved_email';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loadLoginPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      rememberUsername = prefs.getBool(kRememberUsernameKey) ?? false;

      if (rememberUsername) {
        emailController.text = prefs.getString(kSavedEmailKey) ?? '';
      }
    });
  }

  @override
  void initState() {
    super.initState();

    loadLoginPreferences();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            _loginBackground(context),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade200
                  : const Color(0xFF1E1E1E),
                ),
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              icon: Icon(Icons.alternate_email, color: Color(0xFFF78c2ad)),
                              labelText: AppLocalizations.of(context)!.email,
                              hintText: 'abc123@defg.com',
                              labelStyle: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.invalidEmailMsg;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18.0),
                          TextFormField(
                            obscureText: hidePassword,
                            controller: passwordController,
                            decoration: InputDecoration(
                              // border: OutlineInputBorder(),
                              icon: const Icon(Icons.lock_outline, color: Color(0xFFF78c2ad)),
                              labelText: AppLocalizations.of(context)!.password,
                              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                              suffix: InkWell(
                                onTap: togglePasswordView,
                                child: Icon(
                                  hidePassword ? Icons.visibility : Icons.visibility_off,
                                  color: Color(0xFFF78c2ad)
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.emptyPasswordMsg;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28.0),
                          SwitchListTile(
                            value: rememberUsername, 
                            onChanged: (bool value) async {
                              final prefs = await SharedPreferences.getInstance();

                              setState(() => rememberUsername = value);

                              await prefs.setBool(kRememberUsernameKey, value);

                              if(!value) {
                                await prefs.remove(kSavedEmailKey);
                              }
                            },
                            activeThumbColor: Color(0xFFF3969A),
                            title: Text(AppLocalizations.of(context)!.rememberUserSwitch)
                          ),
                          const SizedBox(height: 28.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 95),
                              backgroundColor: Color(0xFFF78c2ad),
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))
                            ),
                            onPressed: isLoading ? null : _handleLogin,
                            child: isLoading 
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                              AppLocalizations.of(context)!.btnEnter,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          FilledButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage())),
                            style: FilledButton.styleFrom(
                              backgroundColor: Color(0xFFF3969A),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.btnRegister,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 29.0),
                    Center(
                      child: Text(
                        'Personal Money © 2021 - 2025', 
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600)
                      )
                    )
                  ],
                ),
              ),

            ],
          ),
      ),
    ));
  }

  Widget _loginBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFF78c2ad),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40.0),
          Image.asset('assets/pigbank.png', width: 96.0),
          const SizedBox(height: 10.0),
          Text(
            'Personal Money', 
            style: TextStyle(
              fontWeight: FontWeight.w600, 
              color: Colors.white,
              fontSize: 22
            ),
          )
        ],
      ));
  }

  bool validatedForm() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();

      return true;
    }

    return false;
  }

  void togglePasswordView() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void _showErrorAlert(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.invalidCredentialsTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.accept),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!validatedForm()) return;

    setState(() {
      isLoading = true;
      loginError = null;
    });

    try {
      await AuthService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (rememberUsername) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(kSavedEmailKey, emailController.text.trim());
      }

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
        (_) => false,
      );
    } catch (e) {
      _showErrorAlert(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

}