import 'package:photo_app/data/files/models/file.dart';
import 'package:photo_app/data/sizes/models/size.dart';

class Order {
  final int id;
  final File file;
  final int clientId;
  final int folderId;
  final Size size;
  final int count;
  Order({
    required this.id,
    required this.file,
    required this.clientId,
    required this.folderId,
    required this.size,
    required this.count,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      file: File.fromJson(json['file']),
      clientId: json['clientId'],
      folderId: json['folderId'],
      size: Size.fromJson(json['size']),
      count: json['count'],
    );
  }
}
