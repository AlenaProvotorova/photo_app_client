import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/files/models/remove_files_req_params.dart';
import 'package:photo_app/domain/files/usecases/remove_files.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_event.dart';
import 'package:photo_app/service_locator.dart';

class ImageDelete extends StatelessWidget {
  final int imageId;
  final int folderId;
  const ImageDelete({
    super.key,
    required this.imageId,
    required this.folderId,
  });

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    final isAdmin = userBloc.state is UserLoaded
        ? (userBloc.state as UserLoaded).user.isAdmin
        : false;
    return isAdmin
        ? Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _handleDeleteFile(context, imageId),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Future<void> _handleDeleteFile(BuildContext context, int id) async {
    // Сначала удаляем локально для плавной анимации
    context.read<FilesBloc>().add(RemoveFileLocally(fileId: id));

    // Ждем завершения анимации перед запросом на сервер
    await Future.delayed(const Duration(milliseconds: 300));

    // Теперь удаляем на сервере
    final result = await sl<RemoveFilesUseCase>().call(
      params: RemoveFilesReqParams(
        ids: [id],
        folderId: folderId,
      ),
    );

    result.fold(
      (error) {
        // Если произошла ошибка, перезагружаем список для восстановления
        context.read<FilesBloc>().add(LoadFiles(folderId: folderId.toString()));
        DisplayMessage.showMessage(context, error.toString());
      },
      (success) {
        // После успешного удаления на сервере, синхронизируем данные
        context.read<FilesBloc>().add(LoadFiles(folderId: folderId.toString()));
      },
    );
  }
}
