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
                    const columnSpacing = 0;
                    const horizontalPadding = 16;
                    const horizontalMargin = 16;

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

                    final columnCount = 2 + sizes.length + photos.length;
                    const fixedColumnWidth =
                        120.0; // Фиксированная ширина столбца
                    final tableWidth = columnCount * fixedColumnWidth;
                    print(
                        'state.fullOrderForTable: ${state.fullOrderForTable}');
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding.toDouble(),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: tableWidth,
                            child: DataTable(
                              dividerThickness: 1,
                              columnSpacing: columnSpacing.toDouble(),
                              horizontalMargin: horizontalMargin.toDouble(),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFE4E4E4),
                                ),
                              ),
                              columns: [
                                DataColumn(
                                  label: SizedBox(
                                    width: fixedColumnWidth,
                                    child: Text(
                                      'В общую',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: fixedColumnWidth,
                                    child: Text(
                                      'Список имен',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ),
                                ),
                                ...photos.map(
                                  (photo) => DataColumn(
                                    label: SizedBox(
                                      width: fixedColumnWidth,
                                      child: Text(
                                        photo['name'],
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                  ),
                                ),
                                ...sizes.map(
                                  (size) => DataColumn(
                                    label: SizedBox(
                                      width: fixedColumnWidth,
                                      child: Text(
                                        size['name'],
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              rows: state.fullOrderForTable
                                  .map((id, details) {
                                    return MapEntry(
                                      id,
                                      DataRow(cells: [
                                        DataCell(
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: fixedColumnWidth),
                                            child: Tooltip(
                                              message: details['fileName'],
                                              child: Text(
                                                details['fileName'],
                                                style:
                                                    theme.textTheme.labelLarge,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            details['clientName'],
                                            style: theme.textTheme.labelLarge,
                                          ),
                                        ),
                                        ...photos.map(
                                          (photo) => DataCell(
                                            _buildPhotoCell(
                                              details['sizes']?[photo['key']],
                                              theme,
                                            ),
                                          ),
                                        ),
                                        ...sizes.map(
                                          (size) => DataCell(Text(
                                            details['sizes'][size['key']]
                                                    ?.toString() ??
                                                '0',
                                            style: theme.textTheme.labelLarge,
                                          )),
                                        ),
                                      ]),
                                    );
                                  })
                                  .values
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildPhotoCell(dynamic value, ThemeData theme) {
    final int count =
        value is int ? value : (int.tryParse(value?.toString() ?? '0') ?? 0);

    if (count == 1) {
      return Icon(
        Icons.check,
        color: Colors.green,
        size: 20,
      );
    } else {
      return Text(
        '-',
        style: theme.textTheme.labelLarge?.copyWith(
          color: Colors.grey,
        ),
      );
    }
  }
}
