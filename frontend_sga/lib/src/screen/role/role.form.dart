// role_form_page.dart
import 'package:flutter/material.dart';
import 'package:frontend_sga/src/models/role.model.dart';
import 'package:frontend_sga/src/service/role.service.dart';

class RoleFormPage extends StatefulWidget {
  const RoleFormPage({super.key});

  @override
  State<RoleFormPage> createState() => _RoleFormPageState();
}

class _RoleFormPageState extends State<RoleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final RoleService _roleService = RoleService();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final role = Role(id: 0, name: _nameController.text);

      try {
        final response = await _roleService.createRole(role);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rol creado exitosamente')),
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
      appBar: AppBar(title: const Text('Registrar Rol')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre del Rol'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un nombre válido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Guardar Rol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
