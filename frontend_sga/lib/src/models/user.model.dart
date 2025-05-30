class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final bool isActive;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.isActive,
    required this.createdAt,
  });

  // Factory constructor para crear un User desde JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Método para convertir User a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
