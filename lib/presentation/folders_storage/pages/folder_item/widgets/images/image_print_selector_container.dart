import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_print_selector.dart';

class ImagePrintSelectorContainer extends StatefulWidget {
  final int imageId;
  final int folderId;
  final Function()? onChangesMade;
  final Function(VoidCallback)? onConfirmCallback;
  const ImagePrintSelectorContainer({
    super.key,
    required this.imageId,
    required this.folderId,
    this.onChangesMade,
    this.onConfirmCallback,
  });

  @override
  State<ImagePrintSelectorContainer> createState() =>
      _ImagePrintSelectorContainerState();
}

class _ImagePrintSelectorContainerState
    extends State<ImagePrintSelectorContainer> {
  Map<String, Map<String, int>>? _cachedOrderData;
  Map<String, int> _pendingChanges = {};
  bool _hasUnconfirmedChanges = false;
  Map<String, int> _confirmedChanges = {};

  final List<String> sizesNames = [
    'sizeOne',
    'sizeTwo',
    'sizeThree',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Регистрируем callback для подтверждения
      if (widget.onConfirmCallback != null) {
        widget.onConfirmCallback!(confirmChanges);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizesBloc = context.read<SizesBloc>();
    final orderBloc = context.read<OrderBloc>();

    int getDefaultQuantity(String sizeName, OrderState orderState) {
      Map<String, Map<String, int>> orderData;

      if (orderState is OrderLoaded) {
        orderData = orderState.orderForCarusel;
        _cachedOrderData = orderData;
      } else if (_cachedOrderData != null) {
        orderData = _cachedOrderData!;
      } else {
        return 0;
      }

      final orders = orderData[widget.imageId.toString()];
      if (orders == null) {
        return 0;
      }

      final result = orders.entries
          .where((element) => element.key == sizeName)
          .fold(0, (sum, entry) => sum + entry.value);
      return result;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sizesBloc),
        BlocProvider.value(value: orderBloc),
      ],
      child: BlocListener<OrderBloc, OrderState>(
        listener: (context, orderState) {
          if (orderState is OrderLoaded) {
            // Когда данные обновились с сервера, очищаем подтвержденные изменения
            setState(() {
              _confirmedChanges.clear();
            });
          }
        },
        child: BlocBuilder<ClientsBloc, ClientsState>(
          builder: (context, clientsState) {
            return BlocBuilder<OrderBloc, OrderState>(
              builder: (context, orderState) {
                return BlocBuilder<FolderSettingsBloc, FolderSettingsState>(
                  builder: (context, settingsState) {
                    if (clientsState is! ClientsLoaded ||
                        clientsState.selectedClient == null) {
                      return const SizedBox.shrink();
                    }

                    if (orderState is! OrderLoaded &&
                        _cachedOrderData == null) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: sizesNames.map((sizeName) {
                              if (settingsState is FolderSettingsLoaded) {
                                if (!settingsState.folderSettings
                                    .getShowProperty(sizeName)) {
                                  return const SizedBox.shrink();
                                }
                                final ruName = settingsState.folderSettings
                                    .getRuNameProperty(sizeName);
                                final price = settingsState.folderSettings
                                    .getPriceProperty(sizeName);

                                String displayName = ruName ?? sizeName;
                                if (price != null && price != 0) {
                                  displayName += ' ($price ₽)';
                                }

                                // Получаем текущее значение (приоритет: pendingChanges -> confirmedChanges -> defaultQuantity)
                                int currentQuantity =
                                    _pendingChanges[sizeName] ??
                                        _confirmedChanges[sizeName] ??
                                        getDefaultQuantity(
                                            sizeName, orderState);

                                return ImagePrintSelector(
                                  size: displayName,
                                  formatName: sizeName,
                                  imageId: widget.imageId,
                                  folderId: widget.folderId,
                                  defaultQuantity: currentQuantity,
                                  isConfirmed: !_hasUnconfirmedChanges,
                                  onQuantityChanged: (newQuantity) {
                                    setState(() {
                                      _pendingChanges[sizeName] = newQuantity;
                                      _hasUnconfirmedChanges = true;
                                    });
                                    // Уведомляем родительский компонент об изменениях
                                    if (widget.onChangesMade != null) {
                                      widget.onChangesMade!();
                                    }
                                  },
                                );
                              }
                              return const SizedBox.shrink();
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void confirmChanges() {
    final clientState = context.read<ClientsBloc>().state;
    if (clientState is ClientsLoaded && clientState.selectedClient != null) {
      final orderBloc = context.read<OrderBloc>();

      for (final entry in _pendingChanges.entries) {
        final event = UpdateOrder(
          fileId: widget.imageId.toString(),
          clientId: clientState.selectedClient!.id.toString(),
          folderId: widget.folderId.toString(),
          formatName: entry.key,
          count: entry.value.toString(),
        );
        orderBloc.add(event);
      }

      setState(() {
        // Сохраняем подтвержденные изменения
        _confirmedChanges.addAll(_pendingChanges);
        _pendingChanges.clear();
        _hasUnconfirmedChanges = false;
      });
    }
  }
}
