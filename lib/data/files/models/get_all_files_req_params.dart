class GetAllFilesReqParams {
  final int folderId;

  GetAllFilesReqParams({
    required this.folderId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'folderId': folderId,
    };
  }
}
