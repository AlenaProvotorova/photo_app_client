import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as router;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_event.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'widgets/order_table.dart';
import 'widgets/digital_orders_header.dart';

class FullOrderScreen extends StatelessWidget {
  final String folderId;
  final String folderPath;
  const FullOrderScreen({
    super.key,
    required this.folderId,
    required this.folderPath,
  });

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ClientsBloc()..add(LoadClients(folderId: folderId)),
        ),
        BlocProvider(
          create: (context) => OrderBloc()..add(LoadOrder(folderId: folderId)),
        ),
        BlocProvider(
          create: (context) =>
              FolderSettingsBloc()..add(LoadFolderSettings(folderId: folderId)),
        ),
      ],
      child: Scaffold(
        appBar: AppBarCustom(
          onPress: () {
            context.go('/folder/$folderPath');
          },
          showLeading: true,
          title: 'Весь заказ',
        ),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OrderLoaded) {
              return BlocBuilder<FolderSettingsBloc, FolderSettingsState>(
                builder: (context, folderSettingsState) {
                  if (folderSettingsState is FolderSettingsLoaded) {
                    // Создаем список размеров на основе настроек папки
                    final List<Map<String, dynamic>> sizes = [];
                    if (folderSettingsState.folderSettings.sizeOne.show) {
                      sizes.add({
                        'name':
                            folderSettingsState.folderSettings.sizeOne.ruName,
                        'key': 'sizeOne'
                      });
                    }
                    if (folderSettingsState.folderSettings.sizeTwo.show) {
                      sizes.add({
                        'name':
                            folderSettingsState.folderSettings.sizeTwo.ruName,
                        'key': 'sizeTwo'
                      });
                    }
                    if (folderSettingsState.folderSettings.sizeThree.show) {
                      sizes.add({
                        'name':
                            folderSettingsState.folderSettings.sizeThree.ruName,
                        'key': 'sizeThree'
                      });
                    }

                    // Создаем список фото полей на основе настроек папки
                    final List<Map<String, dynamic>> photos = [];
                    if (folderSettingsState.folderSettings.photoOne.show) {
                      photos.add({
                        'name':
                            folderSettingsState.folderSettings.photoOne.ruName,
                        'key': 'photoOne'
                      });
                    }
                    if (folderSettingsState.folderSettings.photoTwo.show) {
                      photos.add({
                        'name':
                            folderSettingsState.folderSettings.photoTwo.ruName,
                        'key': 'photoTwo'
                      });
                    }
                    if (folderSettingsState.folderSettings.photoThree.show) {
                      photos.add({
                        'name': folderSettingsState
                            .folderSettings.photoThree.ruName,
                        'key': 'photoThree'
                      });
                    }

                    return Column(
                      children: [
                        const DigitalOrdersHeader(),
                        Expanded(
                          child: OrderTable(
                            fullOrderForTable: state.fullOrderForTable,
                            sizes: sizes,
                            photos: photos,
                            theme: theme,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            }
            if (state is OrderError) {
              return Center(child: Text('Ошибка: ${state.message}'));
            }
            return const Center(child: Text('Нет данных'));
          },
        ),
      ),
    );
  }
}
