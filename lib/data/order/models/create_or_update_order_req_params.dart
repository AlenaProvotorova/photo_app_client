class CreateOrUpdateOrderReqParams {
  final int fileId;
  final int clientId;
  final int folderId;
  final int sizeId;
  final int count;

  CreateOrUpdateOrderReqParams({
    required this.fileId,
    required this.clientId,
    required this.folderId,
    required this.sizeId,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fileId': fileId,
      'clientId': clientId,
      'folderId': folderId,
      'sizeId': sizeId,
      'count': count,
    };
  }
}
