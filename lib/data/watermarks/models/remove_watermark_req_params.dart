class RemoveWatermarkReqParams {
  final int userId;

  RemoveWatermarkReqParams({
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
    };
  }
}
