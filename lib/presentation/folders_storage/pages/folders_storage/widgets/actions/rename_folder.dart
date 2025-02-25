import 'package:flutter/material.dart';
import 'package:photo_app/data/folders/models/folder.dart';

class RenameFolder {
  final Folder folder;
  final Future<void> Function(BuildContext context, int id, String name)
      editFolder;
  RenameFolder({required this.folder, required this.editFolder});

  Future<void> handleRenameFolder(BuildContext context, int id) async {
    showDialog(
      context: context,
      builder: (context) {
        final textController = TextEditingController(text: folder.name);
        return AlertDialog(
          title: const Text('Переименовать папку'),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Новое название',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                final newName = textController.text.trim();
                if (newName.isNotEmpty) {
                  editFolder(context, folder.id, newName);
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
}
