import 'package:flutter/material.dart';
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
                  color: Colors.grey.shade200,
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.alternate_email, color: Colors.teal),
                              labelText: 'Email Address',
                              hintText: 'ejemplo@ejemplo.com',
                              labelStyle: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Insert a valid email';
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
                              labelText: 'Password',
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
                                return 'Insert a password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 120),
                              backgroundColor: Colors.teal
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
                              'Enter',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          TextButton(
                            child: Text(
                              'Registrar Usuario',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: Colors.grey.shade600
                              ),
                            ),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage())),
                          ),
                          // TextButton(
                          //   child: const Text(
                          //     'Continuar sin registro',
                          //     style: TextStyle(
                          //         color: Color(0xFF317039),
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
                    const SizedBox(height: 32.0),
                    Center(child: Column(
                      children: [
                        Text('Personal Money - 2025', style: TextStyle(fontSize: 16)),
                        Icon(Icons.copyright_rounded)
                      ],
                    ))
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
      height: size.height * 0.35,
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
          const SizedBox(height: 30.0),
          Image.asset('assets/pigbank.png', width: 128.0),
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