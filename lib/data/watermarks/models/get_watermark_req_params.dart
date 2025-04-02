class GetAllWatermarksReqParams {
  final int userId;

  GetAllWatermarksReqParams({
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
    };
  }
}
