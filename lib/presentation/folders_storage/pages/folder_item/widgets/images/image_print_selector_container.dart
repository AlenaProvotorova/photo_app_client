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
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_print_selector.dart';

class ImagePrintSelectorContainer extends StatefulWidget {
  final int imageId;
  final int folderId;
  final Function()? onChangesMade;
  final Function(VoidCallback)? onConfirmCallback;
  final Function(bool)? onHasChangesChanged;
  final Map<String, int>? savedPendingChanges;
  final Function(Map<String, int>)? onPendingChangesChanged;
  const ImagePrintSelectorContainer({
    super.key,
    required this.imageId,
    required this.folderId,
    this.onChangesMade,
    this.onConfirmCallback,
    this.onHasChangesChanged,
    this.savedPendingChanges,
    this.onPendingChangesChanged,
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
  Map<String, int> _initialValues = {};

  final List<String> sizesNames = [
    'sizeOne',
    'sizeTwo',
    'sizeThree',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.savedPendingChanges != null &&
        widget.savedPendingChanges!.isNotEmpty) {
      _pendingChanges = Map<String, int>.from(widget.savedPendingChanges!);
      _hasUnconfirmedChanges = _pendingChanges.isNotEmpty;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onConfirmCallback != null) {
        widget.onConfirmCallback!(confirmChanges);
      }
      if (_pendingChanges.isNotEmpty) {
        _checkIfHasChanges();
      }
    });
  }

  Map<String, int> getPendingChanges() {
    return Map<String, int>.from(_pendingChanges);
  }

  bool _isOrderBlocked() {
    final folderSettingsState = context.read<FolderSettingsBloc>().state;
    final userState = context.read<UserBloc>().state;

    if (userState is UserLoaded && userState.user.isAdmin) {
      return false;
    }

    if (folderSettingsState is FolderSettingsLoaded) {
      final dateSelectTo = folderSettingsState.folderSettings.dateSelectTo;

      if (dateSelectTo == null) {
        return false;
      }

      final now = DateTime.now();
      final daysUntilDeadline = dateSelectTo.difference(now).inDays;

      return daysUntilDeadline < 0;
    }

    return false;
  }

  bool _hasChanges() {
    for (final entry in _pendingChanges.entries) {
      final initialValue = _initialValues[entry.key] ?? 0;
      if (entry.value != initialValue) {
        return true;
      }
    }
    return false;
  }

  void _checkIfHasChanges() {
    final hasChanges = _hasChanges();
    widget.onHasChangesChanged?.call(hasChanges);
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

      if (!_initialValues.containsKey(sizeName)) {
        _initialValues[sizeName] = result;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkIfHasChanges();
        });
      }

      return result;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sizesBloc),
        BlocProvider.value(value: orderBloc),
        BlocProvider.value(value: context.read<UserBloc>()),
      ],
      child: BlocListener<OrderBloc, OrderState>(
        listener: (context, orderState) {
          if (orderState is OrderLoaded) {
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

                                int currentQuantity;
                                if (_pendingChanges.containsKey(sizeName)) {
                                  currentQuantity = _pendingChanges[sizeName]!;
                                } else if (_confirmedChanges
                                    .containsKey(sizeName)) {
                                  currentQuantity =
                                      _confirmedChanges[sizeName]!;
                                } else {
                                  currentQuantity =
                                      getDefaultQuantity(sizeName, orderState);
                                }

                                return ImagePrintSelector(
                                  size: displayName,
                                  formatName: sizeName,
                                  imageId: widget.imageId,
                                  folderId: widget.folderId,
                                  defaultQuantity: currentQuantity,
                                  isConfirmed: !_hasUnconfirmedChanges,
                                  isBlocked: _isOrderBlocked(),
                                  onQuantityChanged: (newQuantity) {
                                    final initialValue =
                                        _initialValues[sizeName] ?? 0;

                                    setState(() {
                                      if (newQuantity == initialValue) {
                                        _pendingChanges.remove(sizeName);
                                      } else {
                                        _pendingChanges[sizeName] = newQuantity;
                                      }
                                      _hasUnconfirmedChanges =
                                          _pendingChanges.isNotEmpty;
                                    });

                                    widget.onPendingChangesChanged?.call(
                                        Map<String, int>.from(_pendingChanges));
                                    _checkIfHasChanges();
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
        _initialValues.addAll(_pendingChanges);
        _confirmedChanges.addAll(_pendingChanges);
        _pendingChanges.clear();
        _hasUnconfirmedChanges = false;
      });
      widget.onPendingChangesChanged?.call({});
      _checkIfHasChanges();
    }
  }
}
