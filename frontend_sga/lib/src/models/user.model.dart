class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String? avatar;
  final bool isActive;
  final List<int> roleIds;
  final List<int> permissionIds;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatar,
    this.isActive = true,
    this.roleIds = const [],
    this.permissionIds = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: '', // Nunca viene del backend
      avatar: json['avatar'],
      isActive: json['isActive'] ?? true,
      roleIds: (json['roles'] as List?)?.map((r) => r['id'] as int).toList() ?? [],
      permissionIds:
          (json['permissions'] as List?)?.map((p) => p['id'] as int).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      if (avatar != null) 'avatar': avatar,
      'isActive': isActive,
      'roleIds': roleIds,
      'permissionIds': permissionIds,
    };
  }
}
