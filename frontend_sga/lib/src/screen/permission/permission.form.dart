// permission_form_page.dart
import 'package:flutter/material.dart';
import 'package:frontend_sga/src/models/permission.model.dart';
import 'package:frontend_sga/src/service/permission.service.dart';

class PermissionFormPage extends StatefulWidget {
  const PermissionFormPage({super.key});

  @override
  State<PermissionFormPage> createState() => _PermissionFormPageState();
}

class _PermissionFormPageState extends State<PermissionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final PermissionService _permissionService = PermissionService();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final permission = Permission(id: 0, name: _nameController.text);

      try {
        final response = await _permissionService.createPermission(permission);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso creado exitosamente')),
        );
        _nameController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Permiso')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre del Permiso'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un nombre válido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Guardar Permiso'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
