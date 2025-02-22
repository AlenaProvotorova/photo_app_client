class RemoveFilesReqParams {
  final List<int> ids;
  final int folderId;

  RemoveFilesReqParams({
    required this.ids,
    required this.folderId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ids': ids,
      'folderId': folderId,
    };
  }
}
