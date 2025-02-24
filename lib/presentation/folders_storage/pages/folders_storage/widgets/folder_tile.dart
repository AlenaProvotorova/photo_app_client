import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/folders/models/edit_folder_req_params.dart';
import 'package:photo_app/data/folders/models/folder.dart';
import 'package:photo_app/domain/folders/usecases/edit_folder.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/widgets/actions/delete_folder.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/widgets/actions/popup_menu_action.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/widgets/actions/popup_menu_action_button.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/widgets/actions/rename_folder.dart';
import 'package:photo_app/service_locator.dart';

class FolderTile extends StatelessWidget {
  final Folder folder;
  const FolderTile({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final folderBloc = context.read<FolderBloc>();

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
            onTap: () {
              RenameFolder(
                      folder: folder,
                      editFolder: (ctx, id, name) =>
                          _handleEditFolder(ctx, id, name, folderBloc))
                  .handleRenameFolder(context, folder.id);
            },
          ),
        ],
      ),
      onTap: () {
        context.go('/folder/${folder.id}');
      },
    );
  }

  Future<void> _handleEditFolder(
      BuildContext context, int id, String name, FolderBloc folderBloc) async {
    final result = await sl<EditFolderUseCase>()
        .call(params: EditFolderReqParams(id: id, name: name));

    result.fold(
      (error) => DisplayMessage.showMessage(context, error.toString()),
      (success) {
        Navigator.pop(context);
        folderBloc.add(LoadFolders());
      },
    );
  }
}
