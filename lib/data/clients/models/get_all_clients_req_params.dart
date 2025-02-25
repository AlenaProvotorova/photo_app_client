class GetAllClientsReqParams {
  final int folderId;

  GetAllClientsReqParams({
    required this.folderId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'folderId': folderId,
    };
  }
}
