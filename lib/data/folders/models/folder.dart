class Folder {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;
  Folder({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'],
      name: json['name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
