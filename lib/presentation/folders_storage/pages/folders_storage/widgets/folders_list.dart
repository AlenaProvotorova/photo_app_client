import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/empty_container.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/widgets/folder_tile.dart';

class FoldersList extends StatelessWidget {
  const FoldersList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderBloc, FolderState>(
      builder: (context, state) {
        if (state is FolderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FolderLoaded) {
          if (state.folders.isEmpty) {
            return const EmptyContainer(text: 'Папок нет');
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              itemCount: state.folders.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final folder = state.folders[index];
                return MouseRegion(
                  child: FolderTile(folder: folder),
                );
              },
            ),
          );
        } else if (state is FolderError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No folders found'));
      },
    );
  }
}
