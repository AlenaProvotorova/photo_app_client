class CreateOrUpdateOrderReqParams {
  final int fileId;
  final int clientId;
  final int folderId;
  final String formatName;
  final int count;

  CreateOrUpdateOrderReqParams({
    required this.fileId,
    required this.clientId,
    required this.folderId,
    required this.formatName,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fileId': fileId,
      'clientId': clientId,
      'folderId': folderId,
      'formatName': formatName,
      'count': count,
    };
  }
}
