class Size {
  final int id;
  final String name;
  final String createdAt;
  Size({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Size.fromJson(Map<String, dynamic> json) {
    return Size(
      id: json['id'],
      name: json['name'],
      createdAt: json['createdAt'],
    );
  }
}
