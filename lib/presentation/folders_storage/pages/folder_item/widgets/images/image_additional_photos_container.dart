import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';

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

  void _updateSwitchValuesFromOrder(
      Map<String, Map<String, int>> orderForCarusel) {
    final imageId = widget.imageId.toString();
    final imageOrders = orderForCarusel[imageId];

    if (imageOrders != null) {
      setState(() {
        _photoOne = imageOrders['photoOne'] == 1;
        _photoTwo = imageOrders['photoTwo'] == 1;
        _photoThree = imageOrders['photoThree'] == 1;
      });
    }
  }

  void _initializeSwitchValues() {
    final orderState = context.read<OrderBloc>().state;
    if (orderState is OrderLoaded) {
      _updateSwitchValuesFromOrder(orderState.orderForCarusel);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSwitchValues();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, orderState) {
        if (orderState is OrderLoaded) {
          _updateSwitchValuesFromOrder(orderState.orderForCarusel);
        }
      },
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
                      // Получаем информацию о клиенте для проверки orderAlbum
                      BlocBuilder<ClientsBloc, ClientsState>(
                        builder: (context, clientState) {
                          bool showPhotoOne = false;
                          bool showPhotoTwo = false;
                          bool showPhotoThree = false;

                          if (clientState is ClientsLoaded &&
                              clientState.selectedClient != null) {
                            final orderAlbum =
                                clientState.selectedClient!.orderAlbum;

                            if (orderAlbum == false) {
                              // Если orderAlbum = false, показываем только photoThree
                              showPhotoThree =
                                  state.folderSettings.photoThree.show;
                            } else {
                              // Если orderAlbum = true или null, показываем все доступные фото
                              showPhotoOne = state.folderSettings.photoOne.show;
                              showPhotoTwo = state.folderSettings.photoTwo.show;
                              showPhotoThree =
                                  state.folderSettings.photoThree.show;
                            }
                          } else {
                            // Если клиент не выбран, показываем все доступные фото
                            showPhotoOne = state.folderSettings.photoOne.show;
                            showPhotoTwo = state.folderSettings.photoTwo.show;
                            showPhotoThree =
                                state.folderSettings.photoThree.show;
                          }

                          return Column(
                            children: [
                              if (showPhotoOne)
                                Row(
                                  children: [
                                    Switch(
                                      value: _photoOne,
                                      onChanged: (value) {
                                        setState(() {
                                          _photoOne = value;
                                        });
                                        _updateOrder('photoOne', value);
                                      },
                                    ),
                                    Text(
                                      _getDisplayName(
                                          state.folderSettings.photoOne.ruName,
                                          state.folderSettings.photoOne.price),
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              if (showPhotoTwo)
                                Row(
                                  children: [
                                    Switch(
                                      value: _photoTwo,
                                      onChanged: (value) {
                                        setState(() {
                                          _photoTwo = value;
                                        });
                                        _updateOrder('photoTwo', value);
                                      },
                                    ),
                                    Text(
                                      _getDisplayName(
                                          state.folderSettings.photoTwo.ruName,
                                          state.folderSettings.photoTwo.price),
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              if (showPhotoThree)
                                Row(
                                  children: [
                                    Switch(
                                      value: _photoThree,
                                      onChanged: (value) {
                                        setState(() {
                                          _photoThree = value;
                                        });
                                        _updateOrder('photoThree', value);
                                      },
                                    ),
                                    Text(
                                      _getDisplayName(
                                          state
                                              .folderSettings.photoThree.ruName,
                                          state
                                              .folderSettings.photoThree.price),
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                            ],
                          );
                        },
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
      ),
    );
  }

  void _updateOrder(String formatName, bool value) {
    final clientState = context.read<ClientsBloc>().state;
    if (clientState is ClientsLoaded && clientState.selectedClient != null) {
      final orderBloc = context.read<OrderBloc>();

      // Для типов фото, которые должны иметь единственный выбор
      if (['photoOne', 'photoTwo', 'photoThree'].contains(formatName)) {
        final event = UpdateSingleSelectionOrder(
          fileId: widget.imageId.toString(),
          clientId: clientState.selectedClient!.id.toString(),
          folderId: widget.folderId.toString(),
          formatName: formatName,
          count: value ? '1' : '0',
        );
        orderBloc.add(event);
      } else {
        // Для остальных типов используем обычное обновление
        final event = UpdateOrder(
          fileId: widget.imageId.toString(),
          clientId: clientState.selectedClient!.id.toString(),
          folderId: widget.folderId.toString(),
          formatName: formatName,
          count: value ? '1' : '0',
        );
        orderBloc.add(event);
      }
    }
  }

  // Формирует отображаемое название с ценой
  String _getDisplayName(String? ruName, int? price) {
    String displayName = ruName ?? '';
    if (price != null && price != 0) {
      displayName += ' ($price ₽)';
    }
    return displayName;
  }
}
