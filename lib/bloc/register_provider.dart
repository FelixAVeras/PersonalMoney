import 'package:flutter/material.dart';
import 'package:personalmoney/bloc/register_bloc.dart';
export 'package:personalmoney/bloc/register_bloc.dart';

class CustomRegisterProvider extends InheritedWidget {
  final registerBloc = RegisterBloc();

  CustomRegisterProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static RegisterBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(CustomRegisterProvider)
            as CustomRegisterProvider)
        .registerBloc;
  }
}
