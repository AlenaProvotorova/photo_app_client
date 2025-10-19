class DeleteAllFilesReqParams {
  final int folderId;

  DeleteAllFilesReqParams({
    required this.folderId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'folderId': folderId,
    };
  }
}
