import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://localhost:3000';

  Future<bool> login(String email, String password) async {
  print('[AuthService] Intentando login con email: $email');

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('[AuthService] Código de respuesta: ${response.statusCode}');
    print('[AuthService] Cuerpo de respuesta: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      print('[AuthService] Token recibido: $token');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      print('[AuthService] Token guardado en SharedPreferences');

      return true;
    } else {
      print('[AuthService] Error al iniciar sesión: ${response.body}');
      return false;
    }
  } catch (e) {
    print('[AuthService] Excepción durante login: $e');
    return false;
  }
}


  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
