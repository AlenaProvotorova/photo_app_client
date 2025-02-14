import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/core/helpers/message/dispay_message.dart';
import 'package:photo_app/data/folders/models/create_folder_req_params.dart';
import 'package:photo_app/domain/folders/usecases/create_folder.dart';
import 'package:photo_app/presentation/folders_storage/bloc/folder_bloc.dart';
import 'package:photo_app/presentation/folders_storage/bloc/folder_event.dart';
import 'package:photo_app/presentation/folders_storage/bloc/folder_state.dart';
import 'package:photo_app/service_locator.dart';

class FoldersList extends StatelessWidget {
  const FoldersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        title: 'Пользователь',
      ),
      body: BlocBuilder<FolderBloc, FolderState>(
        builder: (context, state) {
          if (state is FolderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FolderLoaded) {
            return ListView.builder(
              itemCount: state.folders.length,
              itemBuilder: (context, index) {
                final folder = state.folders[index];
                return ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(folder.name),
                  // subtitle: Text('Created: ${folder.createdAt}'),
                );
              },
            );
          } else if (state is FolderError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No folders found'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateFolderDialog(context),
        child: const Icon(Icons.create_new_folder),
      ),
    );
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
          onSubmitted: (_) =>
              _handleCreateFolder(dialogContext, folderNameController),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () =>
                _handleCreateFolder(dialogContext, folderNameController),
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
        DisplayMessage.showMessage(context, 'Folder created successfully');
        Navigator.pop(context);
        controller.clear();
        context.read<FolderBloc>().add(LoadFolders());
      },
    );
  }
}
