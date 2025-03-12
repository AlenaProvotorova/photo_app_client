abstract class OrderEvent {}

class LoadOrder extends OrderEvent {
  final String folderId;
  final String clientId;

  LoadOrder({
    required this.folderId,
    required this.clientId,
  });
}

class UpdateOrder extends OrderEvent {
  final String fileId;
  final String clientId;
  final String folderId;
  final String sizeId;
  final String count;

  UpdateOrder({
    required this.fileId,
    required this.clientId,
    required this.folderId,
    required this.sizeId,
    required this.count,
  });
}
