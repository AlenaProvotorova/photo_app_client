class UpdateClientsReqParams {
  final int folderId;
  final List<Map<String, String>> clients;

  UpdateClientsReqParams({
    required this.folderId,
    required this.clients,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'folderId': folderId,
      'clients': clients,
    };
  }
}
