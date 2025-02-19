abstract class FolderEvent {}

class LoadFolders extends FolderEvent {}

class CreateFolder extends FolderEvent {
  final String name;
  CreateFolder(this.name);
}
