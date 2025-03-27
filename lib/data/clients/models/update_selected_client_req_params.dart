class UpdateSelectedClientReqParams {
  final int clientId;
  final bool orderDigital;

  UpdateSelectedClientReqParams({
    required this.clientId,
    required this.orderDigital,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'clientId': clientId,
      'orderDigital': orderDigital,
    };
  }
}
