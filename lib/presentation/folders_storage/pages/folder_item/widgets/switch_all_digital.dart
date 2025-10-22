import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';

class SwitchAllDigital extends StatefulWidget {
  final String folderId;
  const SwitchAllDigital({
    super.key,
    required this.folderId,
  });

  @override
  State<SwitchAllDigital> createState() => _SwitchAllDigitalState();
}

class _SwitchAllDigitalState extends State<SwitchAllDigital> {
  bool _printAll = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<ClientsBloc, ClientsState>(
      listener: (context, state) {
        if (state is ClientsLoaded && state.selectedClient != null) {
          setState(() {
            _printAll = state.selectedClient!.orderDigital;
          });
        }
      },
      child: BlocBuilder<FolderSettingsBloc, FolderSettingsState>(
        builder: (context, settingsState) {
          if (settingsState is FolderSettingsLoaded &&
              !settingsState.folderSettings.showSelectAllDigital.show) {
            return const SizedBox.shrink();
          }
          return BlocBuilder<ClientsBloc, ClientsState>(
            builder: (context, state) {
              if (state is ClientsLoaded && state.selectedClient != null) {
                return BlocBuilder<FolderSettingsBloc, FolderSettingsState>(
                  builder: (context, settingsState) {
                    if (settingsState is FolderSettingsLoaded) {
                      return Row(
                        children: [
                          Switch(
                            value: _printAll,
                            onChanged: (value) {
                              setState(() {
                                _printAll = value;
                              });
                              context
                                  .read<ClientsBloc>()
                                  .add(UpdateOrderDigital(
                                    clientId:
                                        state.selectedClient!.id.toString(),
                                    orderDigital: value,
                                  ));

                              context.read<OrderBloc>().add(
                                    LoadOrder(
                                      folderId: widget.folderId,
                                      clientId: state.selectedClient!.id,
                                    ),
                                  );
                            },
                          ),
                          Text(
                            _getDisplayName(
                                settingsState
                                    .folderSettings.showSelectAllDigital.ruName,
                                settingsState
                                    .folderSettings.showSelectAllDigital.price),
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  String _getDisplayName(String? ruName, int? price) {
    String displayName = ruName ?? 'ВСЕ ФОТО В ЦИФРОВОМ ВИДЕ';
    if (price != null && price != 0) {
      displayName += ' ($price ₽)';
    }
    return displayName;
  }
}
