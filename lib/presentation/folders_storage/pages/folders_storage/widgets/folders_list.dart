import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/presentation/folders_storage/bloc/folder_bloc.dart';
import 'package:photo_app/presentation/folders_storage/bloc/folder_state.dart';
import 'package:photo_app/presentation/folders_storage/widgets/create_folder_button.dart';
import 'package:photo_app/presentation/folders_storage/widgets/folder_tile.dart';

class FoldersList extends StatelessWidget {
  const FoldersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        title: '',
      ),
      body: BlocBuilder<FolderBloc, FolderState>(
        builder: (context, state) {
          if (state is FolderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FolderLoaded) {
            if (state.folders.isEmpty) {
              return const Center(child: Text('Пустота'));
            }
            return ListView.builder(
              itemCount: state.folders.length,
              itemBuilder: (context, index) {
                final folder = state.folders[index];
                return MouseRegion(
                  child: FolderTile(folder: folder),
                );
              },
            );
          } else if (state is FolderError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No folders found'));
        },
      ),
      floatingActionButton: const CreateFolderButton(),
    );
  }
}
