class User {
  final int id;
  final String email;
  final String password;
  final String name;
  final bool isAdmin;
  final String createdAt;
  final String updatedAt;
  User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      isAdmin: json['isAdmin'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
