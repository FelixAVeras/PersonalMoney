import 'dart:async';

import 'package:personalmoney/bloc/validators.dart';

class RegisterBloc with Validators {
  final _nameController = StreamController<String>.broadcast();
  final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();

  // Get stream data
  Stream<String> get nameStream => _nameController.stream;
  Stream<String> get emailStream =>
      _emailController.stream.transform(validEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validPassword);

  // Insert values to stream
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  dispose() {
    _nameController?.close();
    _emailController?.close();
    _passwordController?.close();
  }
}
