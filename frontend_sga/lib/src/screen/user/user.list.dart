import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend_sga/src/models/user.model.dart';
import 'package:frontend_sga/src/screen/user/user.screen.dart';
import 'package:frontend_sga/src/service/user.service.dart';


class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserService userService = UserService();

  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = userService.getUsers();
    });
  }

  void _deleteUser(int id) async {
    try {
      await userService.deleteUser(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario eliminado')),
      );
      _refreshUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  void _editUser(User user) {
    // Aquí podrías navegar a una pantalla de edición
    // Navigator.push(context, MaterialPageRoute(builder: (_) => EditUserScreen(user: user)));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidad de editar pendiente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay usuarios disponibles'));
          }

          final users = snapshot.data!;

          /*if (users.isNotEmpty) {
      return Container(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserFormPage()), // Reemplaza HomeScreen con tu clase de destino
            );
          },
        ),
      );
          }*/

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editUser(user),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(user.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
