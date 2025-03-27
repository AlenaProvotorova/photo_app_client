abstract class FolderSettingsEvent {}

class LoadFolderSettings extends FolderSettingsEvent {
  final String folderId;

  LoadFolderSettings({required this.folderId});
}

class UpdateFolderSettings extends FolderSettingsEvent {
  final String folderId;
  final Map<String, dynamic> settings;

  UpdateFolderSettings({required this.folderId, required this.settings});
}
