import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/folders/models/delete_folder_req_params.dart';
import 'package:photo_app/data/folders/models/folder.dart';
import 'package:photo_app/domain/folders/usecases/delete_folder.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_event.dart';
import 'package:photo_app/service_locator.dart';

class DeleteFolder {
  final Folder folder;
  const DeleteFolder({required this.folder});

  Future<void> handleDeleteFolder(BuildContext context, int id) async {
    final result = await sl<DeleteFolderUseCase>()
        .call(params: DeleteFolderReqParams(id: id));

    result.fold(
      (error) => DisplayMessage.showMessage(context, error.toString()),
      (success) {
        context.read<FolderBloc>().add(LoadFolders());
      },
    );
  }
}
