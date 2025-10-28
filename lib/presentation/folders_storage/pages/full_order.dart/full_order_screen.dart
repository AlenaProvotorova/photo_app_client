import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as router;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_event.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'widgets/order_table.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_event.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FullOrderScreen extends StatefulWidget {
  final String folderId;
  final String folderPath;
  const FullOrderScreen({
    super.key,
    required this.folderId,
    required this.folderPath,
  });

  @override
  State<FullOrderScreen> createState() => _FullOrderScreenState();
}

class _FullOrderScreenState extends State<FullOrderScreen> {
  final tableKey = GlobalKey<OrderTableState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ClientsBloc()..add(LoadClients(folderId: widget.folderId)),
        ),
        BlocProvider(
          create: (context) =>
              OrderBloc()..add(LoadOrder(folderId: widget.folderId)),
        ),
        BlocProvider(
          create: (context) => FolderSettingsBloc()
            ..add(LoadFolderSettings(folderId: widget.folderId)),
        ),
      ],
      child: Scaffold(
        appBar: AppBarCustom(
          onPress: () {
            context.go('/folder/${widget.folderPath}');
          },
          showLeading: true,
          title: 'Весь заказ',
          actions: [
            BlocProvider(
              create: (context) => UserBloc()..add(LoadUser()),
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, userState) {
                  final bool isAdmin =
                      userState is UserLoaded && userState.user.isAdmin;
                  if (!isAdmin) return const SizedBox.shrink();
                  return IconButton(
                    tooltip: 'Сохранить как изображение',
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      final orderTableState = tableKey.currentState;
                      if (orderTableState == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Таблица не найдена')),
                        );
                        return;
                      }
                      try {
                        final Uint8List bytes =
                            await orderTableState.captureFullImage(context);

                        final String suggestedName =
                            'заказ-${widget.folderPath}.png';

                        String? outputFile = await FilePicker.platform.saveFile(
                          dialogTitle: 'Сохранить заказ как изображение',
                          fileName: suggestedName,
                          type: FileType.custom,
                          allowedExtensions: ['png'],
                        );

                        if (outputFile == null) {
                          return;
                        }

                        final file = File(outputFile);
                        await file.writeAsBytes(bytes);

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Сохранено: $outputFile')),
                        );
                      } catch (e, stackTrace) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ошибка сохранения: $e')),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
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
                    final List<Map<String, dynamic>> sizes = [];
                    if (folderSettingsState.folderSettings.sizeOne.show) {
                      sizes.add({
                        'name': _getDisplayName(
                            folderSettingsState.folderSettings.sizeOne.ruName,
                            folderSettingsState.folderSettings.sizeOne.price),
                        'key': 'sizeOne',
                        'price':
                            folderSettingsState.folderSettings.sizeOne.price ??
                                0
                      });
                    }
                    if (folderSettingsState.folderSettings.sizeTwo.show) {
                      sizes.add({
                        'name': _getDisplayName(
                            folderSettingsState.folderSettings.sizeTwo.ruName,
                            folderSettingsState.folderSettings.sizeTwo.price),
                        'key': 'sizeTwo',
                        'price':
                            folderSettingsState.folderSettings.sizeTwo.price ??
                                0
                      });
                    }
                    if (folderSettingsState.folderSettings.sizeThree.show) {
                      sizes.add({
                        'name': _getDisplayName(
                            folderSettingsState.folderSettings.sizeThree.ruName,
                            folderSettingsState.folderSettings.sizeThree.price),
                        'key': 'sizeThree',
                        'price': folderSettingsState
                                .folderSettings.sizeThree.price ??
                            0
                      });
                    }

                    final List<Map<String, dynamic>> photos = [];
                    if (folderSettingsState.folderSettings.photoOne.show) {
                      photos.add({
                        'name': _getDisplayName(
                            folderSettingsState.folderSettings.photoOne.ruName,
                            folderSettingsState.folderSettings.photoOne.price),
                        'key': 'photoOne',
                        'price':
                            folderSettingsState.folderSettings.photoOne.price ??
                                0
                      });
                    }
                    if (folderSettingsState.folderSettings.photoTwo.show) {
                      photos.add({
                        'name': _getDisplayName(
                            folderSettingsState.folderSettings.photoTwo.ruName,
                            folderSettingsState.folderSettings.photoTwo.price),
                        'key': 'photoTwo',
                        'price':
                            folderSettingsState.folderSettings.photoTwo.price ??
                                0
                      });
                    }
                    if (folderSettingsState.folderSettings.photoThree.show) {
                      photos.add({
                        'name': _getDisplayName(
                            folderSettingsState
                                .folderSettings.photoThree.ruName,
                            folderSettingsState
                                .folderSettings.photoThree.price),
                        'key': 'photoThree',
                        'price': folderSettingsState
                                .folderSettings.photoThree.price ??
                            0
                      });
                    }

                    return BlocBuilder<ClientsBloc, ClientsState>(
                      builder: (context, clientsState) {
                        if (clientsState is ClientsLoaded) {
                          return Column(
                            children: [
                              Expanded(
                                child: OrderTable(
                                  key: tableKey,
                                  fullOrderForTable: state.fullOrderForTable,
                                  sizes: sizes,
                                  photos: photos,
                                  theme: theme,
                                  clients: clientsState.namesList,
                                  digitalPhotoName: folderSettingsState
                                      .folderSettings
                                      .showSelectAllDigital
                                      .ruName,
                                  digitalPhotoPrice: folderSettingsState
                                          .folderSettings
                                          .showSelectAllDigital
                                          .price ??
                                      0,
                                ),
                              ),
                            ],
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
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

  String _getDisplayName(String? ruName, int? price) {
    String displayName = ruName ?? '';
    if (price != null && price != 0) {
      displayName += ' ($price ₽)';
    }
    return displayName;
  }
}
