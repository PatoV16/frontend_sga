// role.service.dart
import 'dart:convert';
import 'package:frontend_sga/src/models/role.model.dart';
import 'package:http/http.dart' as http;

class RoleService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Role>> getRoles() async {
    final response = await http.get(Uri.parse('$baseUrl/roles'));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Role.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener roles');
    }
  }
  Future<Role> createRole(Role role) async {
  final response = await http.post(
    Uri.parse('$baseUrl/roles'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(role.toJson()),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    return Role.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error al crear rol');
  }
}

}
