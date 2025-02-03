class User {
  const User({
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.id,
  });
  final String createdAt;
  final String updatedAt;
  final String email;
  final int id;
}
