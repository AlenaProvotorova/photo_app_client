import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';

class OrderAlbum extends StatefulWidget {
  final String folderId;

  const OrderAlbum({
    super.key,
    required this.folderId,
  });

  @override
  State<OrderAlbum> createState() => _OrderAlbumState();
}

class _OrderAlbumState extends State<OrderAlbum> {
  bool _orderAlbum = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<ClientsBloc, ClientsState>(
      listener: (context, state) {
        if (state is ClientsLoaded && state.selectedClient != null) {
          setState(() {
            _orderAlbum = state.selectedClient!.orderAlbum ?? false;
          });
        }
      },
      child: BlocBuilder<ClientsBloc, ClientsState>(
        builder: (context, state) {
          if (state is ClientsLoaded && state.selectedClient != null) {
            if (state.selectedClient!.orderAlbum == null) {
              return const SizedBox.shrink();
            }

            return BlocBuilder<FolderSettingsBloc, FolderSettingsState>(
              builder: (context, settingsState) {
                if (settingsState is FolderSettingsLoaded) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: Row(
                      children: [
                        Switch(
                          value: _orderAlbum,
                          onChanged: (value) {
                            _showAlbumConfirmationDialog(
                              context,
                              state,
                              settingsState,
                              widget.folderId,
                              value,
                            );
                          },
                        ),
                        Text(
                          _getDisplayName(
                            settingsState.folderSettings.photoOne.ruName,
                            settingsState.folderSettings.photoTwo.ruName,
                          ),
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAlbumConfirmationDialog(
    BuildContext context,
    ClientsLoaded clientState,
    FolderSettingsLoaded settingsState,
    String folderId,
    bool newValue,
  ) {
    final photoOneName = settingsState.folderSettings.photoOne.ruName;
    final photoTwoName = settingsState.folderSettings.photoTwo.ruName;

    String message;
    if (_orderAlbum) {
      message =
          'Отказываясь от альбома вы подтверждаете, что $photoOneName и $photoTwoName не будет в заказе';
    } else {
      message = 'Вам необходимо выбрать фото для $photoOneName и $photoTwoName';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('ОТМЕНА'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateOrderAlbum(clientState, folderId, newValue);
            },
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }

  void _updateOrderAlbum(
      ClientsLoaded clientState, String folderId, bool newValue) {
    setState(() {
      _orderAlbum = newValue;
    });

    context.read<ClientsBloc>().add(UpdateOrderAlbum(
          clientId: clientState.selectedClient!.id.toString(),
          orderAlbum: newValue,
        ));

    if (!newValue) {
      _removePhotoOneAndPhotoTwoFromOrder(clientState, folderId);
    }

    context.read<OrderBloc>().add(
          LoadOrder(
            folderId: folderId,
            clientId: clientState.selectedClient!.id,
          ),
        );
  }

  void _removePhotoOneAndPhotoTwoFromOrder(
      ClientsLoaded clientState, String folderId) {
    final orderBloc = context.read<OrderBloc>();
    final orderState = orderBloc.state;

    if (orderState is OrderLoaded) {
      for (final fileId in orderState.orderForCarusel.keys) {
        orderBloc.add(UpdateSingleSelectionOrder(
          fileId: fileId,
          clientId: clientState.selectedClient!.id.toString(),
          folderId: folderId,
          formatName: 'photoOne',
          count: '0',
        ));

        orderBloc.add(UpdateSingleSelectionOrder(
          fileId: fileId,
          clientId: clientState.selectedClient!.id.toString(),
          folderId: folderId,
          formatName: 'photoTwo',
          count: '0',
        ));
      }
    }
  }

  String _getDisplayName(String? photoOneName, String? photoTwoName) {
    return 'Заказ альбома';
  }
}
