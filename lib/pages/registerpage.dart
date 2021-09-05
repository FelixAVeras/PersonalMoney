import 'package:flutter/material.dart';
import 'package:personalmoney/pages/loginpage.dart';

class RegisterPage extends StatelessWidget {
  String _name;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [_customAppBackground(context), _registerForm(context)],
    ));
  }

  Widget _registerForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final bloc = CustomRegisterProvider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(
            height: 180.0,
          )),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 0.5),
                      spreadRadius: 3.0),
                ]),
            child: Column(
              children: [
                Text(
                  'Registro de Usuario',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 40.0),
                Form(
                    child: Column(
                  children: [
                    _nameField(),
                    SizedBox(height: 40.0),
                    _emailField(),
                    SizedBox(height: 40.0),
                    _passwordField(),
                    SizedBox(height: 60.0),
                    _btnRegister(context)
                  ],
                ))
              ],
            ),
          ),
          SizedBox(height: 40.0),
          ButtonTheme(
              minWidth: 270.0,
              height: 50.0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.teal, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(5.0)),
              child: OutlineButton(
                color: Colors.white,
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()))
                },
                child: Text(
                  'Iniciar Sesion',
                  style: TextStyle(color: Colors.teal),
                ),
              )),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }

  Widget _nameField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        maxLength: 20,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person_outline,
            color: Colors.teal,
          ),
          border: OutlineInputBorder(),
          labelText: 'Nombre y Apellido',
          hintText: 'Tu nombre aqui',
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Este campo es obligatorio';
          }
        },
        onSaved: (String value) {
          _name = value;
        },
      ),
    );
  }

  Widget _emailField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.alternate_email,
            color: Colors.teal,
          ),
          border: OutlineInputBorder(),
          labelText: 'Correo Electronico',
          hintText: 'ejemplo@ejemplo.com',
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Este campo es obligatorio';
          }

          if (!RegExp(
                  "^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*")
              .hasMatch(value)) {
            return 'Email no valido';
          }

          return null;
        },
        onSaved: (String value) {
          _email = value;
        },
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.teal,
          ),
          border: OutlineInputBorder(),
          labelText: 'Contraseña',
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Este campo es obligatorio';
          }
        },
        onSaved: (String value) {
          _password = value;
        },
      ),
    );
  }

  Widget _btnRegister(BuildContext context) {
    return RaisedButton(
      child: Container(
        child: Text('Registrarse'),
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: Colors.teal,
      textColor: Colors.white,
      onPressed: () => {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => HomePage()))
      },
    );
  }

  Widget _customAppBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final backgroundApp = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(26, 188, 156, 1.0),
        Color.fromRGBO(26, 188, 156, 1.0)
      ])),
    );

    return Stack(
      children: [
        backgroundApp,
        Container(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              // Icon(Icons.account_balance_wallet_outlined,
              //     color: Colors.white, size: 100.0),
              Image(image: AssetImage('assets/pigbank.png')),
              SizedBox(height: 10.0, width: double.infinity),
              Text('Personal Money',
                  style: TextStyle(color: Colors.white, fontSize: 25.0))
            ],
          ),
        )
      ],
    );
  }
}
