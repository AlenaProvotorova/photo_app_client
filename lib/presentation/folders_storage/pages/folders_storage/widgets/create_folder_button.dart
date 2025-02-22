import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/folders/models/create_folder_req_params.dart';
import 'package:photo_app/domain/folders/usecases/create_folder.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_event.dart';
import 'package:photo_app/service_locator.dart';

class CreateFolderButton extends StatelessWidget {
  const CreateFolderButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      onPressed: () => _showCreateFolderDialog(context),
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: Colors.white,
      child: const Icon(Icons.create_new_folder),
    );
  }
}

void _showCreateFolderDialog(BuildContext context) {
  final TextEditingController folderNameController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Создать новую папку'),
      content: TextField(
        controller: folderNameController,
        decoration: const InputDecoration(
          hintText: 'Название папки',
        ),
        onSubmitted: (_) => {
          _handleCreateFolder(context, folderNameController),
          Navigator.pop(context),
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            _handleCreateFolder(context, folderNameController);
            Navigator.pop(context);
          },
          child: const Text('Создать'),
        ),
      ],
    ),
  );
}

Future<void> _handleCreateFolder(
    BuildContext context, TextEditingController controller) async {
  final result = await sl<CreateFolderUseCase>().call(
    params: CreateFolderReqParams(name: controller.text),
  );

  result.fold(
    (error) => DisplayMessage.showMessage(context, error),
    (success) {
      context.read<FolderBloc>().add(LoadFolders());
    },
  );
}
