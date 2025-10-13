class UserListItem {
  final int id;
  final String email;
  final String name;
  final bool isAdmin;
  final bool isSuperUser;
  final String createdAt;
  final String updatedAt;

  UserListItem({
    required this.id,
    required this.email,
    required this.name,
    required this.isAdmin,
    required this.isSuperUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserListItem.fromJson(Map<String, dynamic> json) {
    return UserListItem(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      isSuperUser: json['isSuperUser'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
