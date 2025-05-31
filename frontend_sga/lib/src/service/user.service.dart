import 'dart:convert';
import 'package:frontend_sga/src/models/user.model.dart';
import 'package:http/http.dart' as http;


class UserService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Usuario no encontrado');
    }
  }

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear usuario');
    }
  }

  Future<User> updateUser(int id, User user) async {
  final response = await http.patch(
    Uri.parse('$baseUrl/users/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(user.toJson()),
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error al actualizar usuario');
  }
}


  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar usuario');
    }
  }
}
