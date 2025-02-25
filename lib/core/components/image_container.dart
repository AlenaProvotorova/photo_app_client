import 'package:flutter/material.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/files/models/remove_files_req_params.dart';
import 'package:photo_app/domain/files/usecases/remove_files.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_event.dart';
import 'package:photo_app/service_locator.dart';
import 'package:provider/provider.dart';

class ImageContainer extends StatelessWidget {
  final int folderId;
  final String url;
  final int id;

  const ImageContainer({
    super.key,
    required this.folderId,
    required this.url,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = (screenWidth - 32 - 16) / 3;

    return Stack(
      children: [
        Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => _handleDeleteFile(context, id),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleDeleteFile(BuildContext context, int id) async {
    final result = await sl<RemoveFilesUseCase>().call(
      params: RemoveFilesReqParams(
        ids: [id],
        folderId: folderId,
      ),
    );
    result.fold(
      (error) => DisplayMessage.showMessage(context, error.toString()),
      (success) {
        context.read<FilesBloc>().add(LoadFiles(folderId: folderId.toString()));
      },
    );
  }
}
