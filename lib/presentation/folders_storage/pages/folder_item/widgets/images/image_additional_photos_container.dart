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

  void _updateSwitchValues(Map<String, Map<String, int>> orderForCarusel) {
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
      _updateSwitchValues(orderState.orderForCarusel);
    }
  }

  @override
  void initState() {
    super.initState();
    // Инициализируем значения после построения виджета
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
          _updateSwitchValues(orderState.orderForCarusel);
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
                      if (state.folderSettings.photoOne.show)
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
                                _updateOrder('photoTwo', value);
                                // context
                                //     .read<ClientsBloc>()
                                //     .add(UpdateOrderDigital(
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
                                _updateOrder('photoThree', value);
                                // context
                                //     .read<ClientsBloc>()
                                //     .add(UpdateOrderDigital(
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
      ),
    );
  }

  void _updateOrder(String formatName, bool value) {
    final clientState = context.read<ClientsBloc>().state;
    if (clientState is ClientsLoaded && clientState.selectedClient != null) {
      final orderBloc = context.read<OrderBloc>();

      final event = UpdateOrder(
        fileId: widget.imageId.toString(),
        clientId: clientState.selectedClient!.id.toString(),
        folderId: widget.folderId.toString(),
        formatName: formatName,
        count: value.toString(),
      );

      orderBloc.add(event);
    }
  }
}
