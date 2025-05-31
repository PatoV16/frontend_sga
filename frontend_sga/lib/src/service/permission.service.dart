// permission.service.dart
import 'dart:convert';
import 'package:frontend_sga/src/models/permission.model.dart';
import 'package:http/http.dart' as http;

class PermissionService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Permission>> getPermissions() async {
    final response = await http.get(Uri.parse('$baseUrl/permissions'));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Permission.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener permisos');
    }
  }
  Future<Permission> createPermission(Permission permission) async {
  final response = await http.post(
    Uri.parse('$baseUrl/permissions'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(permission.toJson()),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    return Permission.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error al crear permiso');
  }
}

}
