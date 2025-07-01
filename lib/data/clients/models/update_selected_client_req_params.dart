class UpdateSelectedClientReqParams {
  final int clientId;
  final bool? orderDigital;
  final bool? orderAlbum;

  UpdateSelectedClientReqParams({
    required this.clientId,
    this.orderDigital,
    this.orderAlbum,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'clientId': clientId,
      'orderDigital': orderDigital,
      'orderAlbum': orderAlbum,
    };
  }
}
