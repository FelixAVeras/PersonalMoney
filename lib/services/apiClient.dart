import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:personalmoney/services/authService.dart';

class ApiClient {
  static Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      },
      body: body,
    );

    _handleResponse(response);

    return response;
  }

  static void _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      await AuthService.logout();
      throw Exception('Session expired. Please login again.');
    }
  }
}
