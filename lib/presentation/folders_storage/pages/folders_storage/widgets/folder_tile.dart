import 'package:flutter/material.dart';
import 'package:photo_app/data/folders/models/folder.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/widgets/delete_folder.dart';

class FolderTile extends StatelessWidget {
  final Folder folder;
  const FolderTile({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.folder, color: Colors.blue),
      title: Text(folder.name),
      trailing: DeleteFolder(folder: folder),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/folder/${folder.id}',
        );
      },
    );
  }
}
