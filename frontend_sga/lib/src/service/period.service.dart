import 'dart:convert';
import 'package:frontend_sga/src/models/period.model.dart';
import 'package:http/http.dart' as http;
class PeriodService {
  final String baseUrl = 'http://localhost:3000/periods';

  Future<List<Period>> getPeriods() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Period.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar periods');
    }
  }

  Future<Period> getPeriodById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Period.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Period no encontrado');
    }
  }

  Future<Period> createPeriod(Period period) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(period.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Period.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear period');
    }
  }

  Future<Period> updatePeriod(int id, Period period) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(period.toJson()),
    );
    if (response.statusCode == 200) {
      return Period.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar period');
    }
  }

  Future<void> deletePeriod(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar period');
    }
  }
}
