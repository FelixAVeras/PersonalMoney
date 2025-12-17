import 'package:flutter/material.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/pages/auth/registerPage.dart';
import 'package:personalmoney/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool hidePassword = true;

  bool isRemember = false;

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
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.alternate_email, color: Colors.teal),
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.teal),
                              labelText: AppLocalizations.of(context)!.password,
                              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                              suffix: InkWell(
                                onTap: togglePasswordView,
                                child: Icon(
                                  hidePassword ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.teal,
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 95),
                              backgroundColor: Colors.teal,
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))
                            ),
                            onPressed: () {
                              if (validatedForm()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomePage()),
                                );
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.btnEnter,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          FilledButton.tonal(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage())),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.btnRegister,
                            ),
                          ),
                          // const SizedBox(height: 15.0),
                          // TextButton(
                          //   child: Text(
                          //     AppLocalizations.of(context)!.continueWithoutAccount,
                          //     style: TextStyle(
                          //         color: Colors.red.shade300,
                          //         fontWeight: FontWeight.w600,
                          //         fontSize: 16),
                          //   ),
                          //   onPressed: () => Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => HomePage()),
                          //   ),
                          // )
                          
                        ],
                      ),
                    ),
                    const SizedBox(height: 29.0),
                    Center(
                      child: Text(
                        'Personal Money © 2021', 
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

  // void togglePasswordView() {
  //   setState(() {
  //     hidePassword = !hidePassword;
  //   });
  // }

  Widget _loginBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.teal,
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
}