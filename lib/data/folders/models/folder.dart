class Folder {
  final int id;
  final String name;
  final String url;
  final String createdAt;
  final String updatedAt;
  final DateTime? deletedAt;
  Folder({
    required this.id,
    required this.name,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}
