class GetFolderSettingsReqParams {
  final int folderId;

  GetFolderSettingsReqParams({
    required this.folderId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'folderId': folderId,
    };
  }
}
