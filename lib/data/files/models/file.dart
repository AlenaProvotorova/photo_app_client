class File {
  final int id;
  final String filename;
  final String originalName;
  final int size;
  final String mimetype;
  final String? deletedAt;
  final String url;
  File({
    required this.id,
    required this.filename,
    required this.originalName,
    required this.size,
    required this.mimetype,
    this.deletedAt,
    required this.url,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      id: json['id'],
      filename: json['filename'],
      originalName: json['originalName'],
      size: json['size'],
      mimetype: json['mimetype'],
      deletedAt: json['deletedAt'],
      url: json['url'],
    );
  }
}
