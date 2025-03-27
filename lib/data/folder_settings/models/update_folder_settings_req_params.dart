class UpdateFolderSettingsReqParams {
  final int folderId;
  final Map<String, dynamic> settings;

  UpdateFolderSettingsReqParams({
    required this.folderId,
    required this.settings,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'folderId': folderId,
    };
  }
}
