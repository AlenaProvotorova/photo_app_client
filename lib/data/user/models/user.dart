class User {
  final int id;
  final String email;
  final String password;
  final String name;
  final bool isAdmin;
  final bool isSuperUser;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.isAdmin,
    required this.isSuperUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      isSuperUser: json['isSuperUser'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
