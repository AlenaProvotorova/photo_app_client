import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/widgets/folders_list.dart';
import 'package:photo_app/service_locator.dart';

class FoldersStorageScreen extends StatefulWidget {
  const FoldersStorageScreen({super.key});

  @override
  State<FoldersStorageScreen> createState() => _FoldersStorageScreenState();
}

class _FoldersStorageScreenState extends State<FoldersStorageScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FolderBloc>()..add(LoadFolders()),
      child: const Scaffold(
        appBar: AppBarCustom(
          title: 'Файлы',
        ),
        body: FoldersList(),
      ),
    );
  }
}
