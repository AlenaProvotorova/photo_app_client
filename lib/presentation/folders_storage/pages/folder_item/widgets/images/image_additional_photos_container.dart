import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';

class ImageAdditionalPhotosContainer extends StatefulWidget {
  final int imageId;
  final int folderId;
  const ImageAdditionalPhotosContainer({
    super.key,
    required this.imageId,
    required this.folderId,
  });

  @override
  State<ImageAdditionalPhotosContainer> createState() =>
      _ImageAdditionalPhotosContainerState();
}

class _ImageAdditionalPhotosContainerState
    extends State<ImageAdditionalPhotosContainer> {
  bool _photoOne = false;
  bool _photoTwo = false;
  bool _photoThree = false;

  @override
  Widget build(BuildContext context) {
    final folderSettingsBloc = context.read<FolderSettingsBloc>();
    final theme = Theme.of(context);
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: folderSettingsBloc),
        ],
        child: BlocBuilder<FolderSettingsBloc, FolderSettingsState>(
          builder: (context, state) {
            if (state is FolderSettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FolderSettingsLoaded) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (state.folderSettings.photoOne.show)
                          Row(
                            children: [
                              Switch(
                                value: _photoOne,
                                onChanged: (value) {
                                  setState(() {
                                    _photoOne = value;
                                  });
                                  // context
                                  //     .read<ClientsBloc>()
                                  //     .add(UpdateSelectedClient(
                                  //       clientId:
                                  //           state.selectedClient!.id.toString(),
                                  //       orderDigital: value,
                                  //     ));
                                },
                              ),
                              Text(
                                state.folderSettings.photoOne.ruName,
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        if (state.folderSettings.photoTwo.show)
                          Row(
                            children: [
                              Switch(
                                value: _photoTwo,
                                onChanged: (value) {
                                  setState(() {
                                    _photoTwo = value;
                                  });
                                  // context
                                  //     .read<ClientsBloc>()
                                  //     .add(UpdateSelectedClient(
                                  //       clientId:
                                  //           state.selectedClient!.id.toString(),
                                  //       orderDigital: value,
                                  //     ));
                                },
                              ),
                              Text(
                                state.folderSettings.photoTwo.ruName,
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        if (state.folderSettings.photoThree.show)
                          Row(
                            children: [
                              Switch(
                                value: _photoThree,
                                onChanged: (value) {
                                  setState(() {
                                    _photoThree = value;
                                  });
                                  // context
                                  //     .read<ClientsBloc>()
                                  //     .add(UpdateSelectedClient(
                                  //       clientId:
                                  //           state.selectedClient!.id.toString(),
                                  //       orderDigital: value,
                                  //     ));
                                },
                              ),
                              Text(
                                state.folderSettings.photoThree.ruName,
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }
            if (state is FolderSettingsError) {
              return const Center(child: Text('Ошибка загрузки'));
            }
            return const Center(child: Text(''));
          },
        ));
  }
}
