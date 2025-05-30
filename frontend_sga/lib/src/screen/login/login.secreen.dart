import 'package:flutter/material.dart';
import 'package:frontend_sga/src/screen/user/user.list.dart';
import 'package:frontend_sga/src/service/aut.service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://localhost:3000'; // Replace with your actual API base URL

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;
  String errorMsg = '';

  Future<bool> _login(String email, String password) async {
  print('[AuthService] Intentando login con email: $email');

  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  print('[AuthService] Código de respuesta: ${response.statusCode}');
  print('[AuthService] Cuerpo de respuesta: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);
    final token = data['access_token'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserListScreen()), // Reemplaza HomeScreen con tu clase de destino
            );
    print('[AuthService] Token guardado correctamente');
    return true;
  } else {
    print('[AuthService] Error al iniciar sesión: ${response.body}');
    return false;
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (errorMsg.isNotEmpty)
              Text(errorMsg, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);
                      final success = await _login(
                        emailController.text,
                        passwordController.text,
                      );
                      setState(() {
                        isLoading = false;
                        errorMsg = success ? '' : 'Error al iniciar sesión';
                      });
                    },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
