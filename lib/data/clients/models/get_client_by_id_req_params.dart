class GetClientByIdReqParams {
  final int clientId;

  GetClientByIdReqParams({
    required this.clientId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'clientId': clientId,
    };
  }
}
