class Client {
  final int id;
  final String name;
  final int folderId;
  final bool orderDigital;
  final bool? orderAlbum;

  Client({
    required this.id,
    required this.name,
    required this.folderId,
    required this.orderDigital,
    required this.orderAlbum,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      folderId: json['folderId'],
      orderDigital: json['orderDigital'],
      orderAlbum: json['orderAlbum'],
    );
  }
}
