class GetOrderReqParams {
  final int folderId;
  final int? clientId;

  GetOrderReqParams({
    required this.folderId,
    this.clientId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'folderId': folderId,
      'clientId': clientId,
    };
  }
}
