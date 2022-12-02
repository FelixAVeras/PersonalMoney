import 'package:flutter/material.dart';
import 'package:personalmoney/bloc/login_bloc.dart';
export 'package:personalmoney/bloc/login_bloc.dart';

class CustomProvider extends InheritedWidget {
  final loginBloc = LoginBloc();

  CustomProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>()).loginBloc;
  }
}
