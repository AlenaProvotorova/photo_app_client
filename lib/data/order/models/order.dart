class Order {
  final int id;
  final int fileId;
  final int clientId;
  final int folderId;
  final int sizeId;
  final int count;
  Order({
    required this.id,
    required this.fileId,
    required this.clientId,
    required this.folderId,
    required this.sizeId,
    required this.count,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      fileId: json['fileId'],
      clientId: json['clientId'],
      folderId: json['folderId'],
      sizeId: json['sizeId'],
      count: json['count'],
    );
  }
}
