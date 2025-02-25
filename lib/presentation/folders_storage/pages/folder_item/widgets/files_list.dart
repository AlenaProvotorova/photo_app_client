import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/files_container.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/upload_file_button.dart';

class FilesList extends StatelessWidget {
  final String folderId;
  final Function(BuildContext) onPickImages;
  const FilesList(
      {super.key, required this.folderId, required this.onPickImages});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilesBloc, FilesState>(
      builder: (context, state) {
        if (state is FilesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FilesLoaded) {
          return Column(
            children: [
              FilesContainer(
                files: state.files,
                folderId: folderId,
              ),
              UploadFileButton(
                pickImages: (context) async {
                  await onPickImages(context);
                },
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
}
