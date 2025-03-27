import 'package:photo_app/data/folders/models/folder.dart';

class Client {
  final int id;
  final String name;
  final int folderId;
  final bool orderDigital;
  Client({
    required this.id,
    required this.name,
    required this.folderId,
    required this.orderDigital,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      folderId: json['folderId'],
      orderDigital: json['orderDigital'],
    );
  }
}
