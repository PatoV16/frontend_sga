// dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:frontend_sga/src/screen/periods/period.form.dart';
import 'package:frontend_sga/src/screen/permission/permission.form.dart';
import 'package:frontend_sga/src/screen/role/role.form.dart';
import 'package:frontend_sga/src/screen/user/user.list.dart';
import 'package:frontend_sga/src/screen/user/user.screen.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _DashboardButton(
              title: '📄 Lista de Usuarios',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserListScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _DashboardButton(
              title: '🧍 Registrar Usuario',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserFormPage()),
              ),
            ),
            const SizedBox(height: 12),
            _DashboardButton(
              title: '🛡️ Registrar Rol',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RoleFormPage()),
              ),
            ),
            const SizedBox(height: 12),
            _DashboardButton(
              title: '🔐 Registrar Permiso',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PermissionFormPage()),
              ),
            ),
            const SizedBox(height: 12),
              _DashboardButton(
              title: ' Registrar Periodo',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PeriodFormPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DashboardButton({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        textStyle: const TextStyle(fontSize: 16),
      ),
      onPressed: onTap,
      child: Text(title),
    );
  }
}
