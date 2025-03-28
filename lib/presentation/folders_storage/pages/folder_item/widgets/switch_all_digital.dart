import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';

class SwitchAllDigital extends StatefulWidget {
  const SwitchAllDigital({
    super.key,
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
              !settingsState.folderSettings.showSelectAllDigital) {
            return const SizedBox.shrink();
          }
          return BlocBuilder<ClientsBloc, ClientsState>(
            builder: (context, state) {
              if (state is ClientsLoaded && state.selectedClient != null) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Switch(
                        value: _printAll,
                        onChanged: (value) {
                          setState(() {
                            _printAll = value;
                          });
                          context.read<ClientsBloc>().add(UpdateSelectedClient(
                                clientId: state.selectedClient!.id.toString(),
                                orderDigital: value,
                              ));
                        },
                      ),
                      Text(
                        'ВСЕ ФОТО В ЦИФРОВОМ ВИДЕ',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
