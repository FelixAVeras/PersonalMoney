import 'package:flutter/material.dart';
// import 'package:personalmoney/bloc/provider.dart';
import 'package:personalmoney/pages/homepage.dart';
import 'package:personalmoney/pages/registerpage.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool hidePassword = true;

  @override
  void initState() {
    // httpService = new APIHttpService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [_customLoginAppBackground(context), _loginForm(context)],
    ));
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final bloc = CustomProvider.of(context);

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
                  'Inicio de Sesion',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 40.0),
                // _emailField(bloc),
                _emailField(),
                SizedBox(height: 40.0),
                // _passwordField(bloc),
                _passwordField(),
                SizedBox(height: 40.0),
                _btnLogin(context)
              ],
            ),
          ),
          // SizedBox(height: 40.0),
          // Text('Olvido su contraseña?'),
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
                      MaterialPageRoute(builder: (context) => RegisterPage()))
                },
                child: Text(
                  'Registrar Usuario',
                  style: TextStyle(color: Colors.teal),
                ),
              )),
          // OutlineButton(
          //   onPressed: () => {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => RegisterPage()))
          //   },
          //   child: Text('Registrar Usuario'),
          // ),
          SizedBox(height: 40.0),
          // Text(
          //   'IF Software - ©2021',
          //   style: TextStyle(color: Colors.grey[400]),
          // ),
          // SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _emailField() {
    return StreamBuilder(
        // stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.alternate_email,
                color: Theme.of(context).primaryColor,
              ),
              labelText: 'Correo Electronico',
              hintText: 'ejemplo@ejemplo.com',
              counterText: snapshot.data),
          // onChanged: bloc.changeEmail,
        ),
      );
    });
  }

  Widget _passwordField() {
    return StreamBuilder(
        // stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          obscureText: hidePassword,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Theme.of(context).primaryColor,
              ),
              suffix: InkWell(
                onTap: togglePasswordView,
                child: Icon(
                    hidePassword ? Icons.visibility : Icons.visibility_off),
              ),
              border: OutlineInputBorder(),
              labelText: 'Contraseña',
              counterText: snapshot.data),
          // onChanged: bloc.changePassword,
        ),
      );
    });
  }

  Widget _btnLogin(BuildContext context) {
    return RaisedButton(
      child: Container(
        child: Text('Iniciar Sesion'),
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()))
      },
    );
  }

  Widget _customLoginAppBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final backgroundApp = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(26, 188, 156, 1.0),
        Color.fromRGBO(26, 188, 156, 1.0)
        // Color.fromRGBO(26, 188, 156, 1.0)
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

  void togglePasswordView() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }
}
