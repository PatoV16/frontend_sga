import 'package:flutter/material.dart';
import 'package:frontend_sga/src/models/user.model.dart';
import 'package:frontend_sga/src/service/permission.service.dart';
import 'package:frontend_sga/src/service/role.service.dart';
import 'package:frontend_sga/src/service/user.service.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final UserService _userService = UserService();

  List<Map<String, dynamic>> availableRoles = [];
  List<Map<String, dynamic>> availablePermissions = [];

  List<int> selectedRoleIds = [];
  List<int> selectedPermissionIds = [];

  @override
  void initState() {
    super.initState();
    _loadRolesAndPermissions();
  }

  Future<void> _loadRolesAndPermissions() async {
  final roles = await RoleService().getRoles();
  final permissions = await PermissionService().getPermissions();

  setState(() {
    availableRoles = roles.map((r) => {'id': r.id, 'name': r.name}).toList();
    availablePermissions = permissions.map((p) => {'id': p.id, 'name': p.name}).toList();
  });
}


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        isActive: true,
        roleIds: selectedRoleIds,
        permissionIds: selectedPermissionIds,
      );

      try {
        await _userService.createUser(user);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado exitosamente')),
        );
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        setState(() {
          selectedRoleIds.clear();
          selectedPermissionIds.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildCheckboxList({
    required String title,
    required List<Map<String, dynamic>> items,
    required List<int> selectedIds,
    required Function(bool?, int) onChanged,
  }) {
    return ExpansionTile(
      title: Text(title),
      children: items
          .map((item) => CheckboxListTile(
                value: selectedIds.contains(item['id']),
                title: Text(item['name']),
                onChanged: (bool? value) => onChanged(value, item['id']),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Ingresa tu nombre' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Ingresa un correo válido' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 16),
              _buildCheckboxList(
                title: 'Roles',
                items: availableRoles,
                selectedIds: selectedRoleIds,
                onChanged: (value, id) {
                  setState(() {
                    value!
                        ? selectedRoleIds.add(id)
                        : selectedRoleIds.remove(id);
                  });
                },
              ),
              _buildCheckboxList(
                title: 'Permisos',
                items: availablePermissions,
                selectedIds: selectedPermissionIds,
                onChanged: (value, id) {
                  setState(() {
                    value!
                        ? selectedPermissionIds.add(id)
                        : selectedPermissionIds.remove(id);
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
