import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';

class ImageOrderInfo extends StatelessWidget {
  final int imageId;
  const ImageOrderInfo({
    super.key,
    required this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20,
      child: BlocBuilder<FolderSettingsBloc, FolderSettingsState>(
        builder: (context, folderSettingsState) {
          if (folderSettingsState is FolderSettingsLoaded) {
            final settings = folderSettingsState.folderSettings;
            return BlocBuilder<ClientsBloc, ClientsState>(
              builder: (context, clientsState) {
                return BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    if (clientsState is ClientsLoaded &&
                        clientsState.selectedClient != null &&
                        state is OrderLoaded &&
                        state.orderForCarusel.containsKey(imageId.toString())) {
                      final sizes = state.orderForCarusel[imageId.toString()]!;

                      final orderedKeys = [
                        'photoOne',
                        'photoTwo',
                        'photoThree',
                        'sizeOne',
                        'sizeTwo',
                        'sizeThree'
                      ];
                      final sizeText = orderedKeys
                          .where((key) =>
                              sizes.containsKey(key) && sizes[key] != 0)
                          .map((key) {
                        if (key.startsWith('photo')) {
                          return settings.getRuNameProperty(key);
                        } else {
                          return '${settings.getRuNameProperty(key)} - ${sizes[key]}';
                        }
                      }).join('\n');
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          sizeText,
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
