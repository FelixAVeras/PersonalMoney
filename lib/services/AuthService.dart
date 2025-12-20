import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'https://apiurl.com/api';
  static const String _tokenKey = 'auth_token';

  //Login
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      await saveToken(data["token"]);

      return true;
    }

    return false;
  }

  // //Registro
  // static Future<bool> register(String name, String lastname, String email, String password, bool is_premium) async {
  //   final url = Uri.parse("$baseUrl/register");
  //   final response = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"name": name, "lastname": lastname, "email": email, "password": password, "is_premium": is_premium}),
  //   );

  //   if (response.statusCode == 200) {
  //     // Una vez registrado, también podemos loguearlo automáticamente
  //     final data = jsonDecode(response.body);
  //     // tu API devuelve el user, no el token. Si quieres que devuelva token,
  //     // puedes modificar NodeJS; por ahora solo confirmamos éxito
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    if (token == null) return false;

    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    }

    // Token inválido o expirado
    await logout();
    
    return false;
  }

  // static Future<void> saveToken(String token) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString("token", token);
  // }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, token);
  }
}