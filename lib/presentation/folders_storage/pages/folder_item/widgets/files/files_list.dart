import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/files/files_container.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/upload_progress_loader.dart';

class FilesList extends StatelessWidget {
  final String folderId;
  final OrderBloc orderBloc;
  final ClientsBloc clientsBloc;
  final bool showSelected;
  const FilesList({
    super.key,
    required this.folderId,
    required this.orderBloc,
    required this.clientsBloc,
    required this.showSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilesBloc, FilesState>(
      builder: (context, state) {
        if (state is FilesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FilesUploading) {
          return _buildUploadingState(context, state);
        } else if (state is FilesLoaded) {
          return Column(
            children: [
              FilesContainer(
                files: state.files,
                folderId: folderId,
                orderBloc: orderBloc,
                clientsBloc: clientsBloc,
                showSelected: showSelected,
              ),
            ],
          );
        } else if (state is FilesError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No files found'));
      },
    );
  }

  Widget _buildUploadingState(BuildContext context, FilesUploading state) {
    return Column(
      children: [
        // Прогресс загрузки
        UploadProgressLoader(
          totalFiles: state.totalFiles,
          uploadedFiles: state.uploadedFiles,
          failedFiles: state.failedFiles,
          remainingFiles: state.remainingFiles,
          progress: state.progress,
        ),

        // Существующие файлы
        if (state.existingFiles.isNotEmpty)
          Expanded(
            child: FilesContainer(
              files: state.existingFiles,
              folderId: folderId,
              orderBloc: orderBloc,
              clientsBloc: clientsBloc,
              showSelected: showSelected,
            ),
          )
        else
          const Expanded(
            child: Center(
              child: Text('Загрузка изображений...'),
            ),
          ),
      ],
    );
  }
}
