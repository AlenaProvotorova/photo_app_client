import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_app/data/folders/models/folder.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/widgets/actions/delete_folder.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/widgets/actions/popup_menu_action.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/widgets/actions/popup_menu_action_button.dart';

class FolderTile extends StatelessWidget {
  final Folder folder;
  const FolderTile({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.folder,
          color: Colors.white,
        ),
      ),
      title: Text(folder.name),
      trailing: PopupMenuButtonWidget(
        actions: [
          PopupMenuAction(
            title: 'Удалить',
            onTap: () {
              DeleteFolder(folder: folder)
                  .handleDeleteFolder(context, folder.id);
            },
          ),
          PopupMenuAction(
            title: 'Переименовать',
            onTap: () {},
          ),
        ],
      ),
      onTap: () {
        context.go('/folder/${folder.id}');
      },
    );
  }
}
