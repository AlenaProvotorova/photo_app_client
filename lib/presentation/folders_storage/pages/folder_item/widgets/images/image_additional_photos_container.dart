import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';

class ImageAdditionalPhotosContainer extends StatefulWidget {
  final int imageId;
  final int folderId;
  final Function()? onChangesMade;
  final Function(VoidCallback)? onConfirmCallback;
  final Function(bool)? onHasChangesChanged;
  final Map<String, bool>? savedPendingChanges;
  final Function(Map<String, bool>)? onPendingChangesChanged;
  const ImageAdditionalPhotosContainer({
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
  State<ImageAdditionalPhotosContainer> createState() =>
      _ImageAdditionalPhotosContainerState();
}

class _ImageAdditionalPhotosContainerState
    extends State<ImageAdditionalPhotosContainer> {
  bool _photoOne = false;
  bool _photoTwo = false;
  bool _photoThree = false;

  Map<String, bool> _pendingChanges = {};
  Map<String, bool> _initialValues = {};

  void _updateSwitchValuesFromOrder(
      Map<String, Map<String, int>> orderForCarusel) {
    final imageId = widget.imageId.toString();
    final imageOrders = orderForCarusel[imageId];

    if (imageOrders != null) {
      setState(() {
        _photoOne = imageOrders['photoOne'] == 1;
        _photoTwo = imageOrders['photoTwo'] == 1;
        _photoThree = imageOrders['photoThree'] == 1;

        if (_initialValues.isEmpty) {
          _initialValues['photoOne'] = _photoOne;
          _initialValues['photoTwo'] = _photoTwo;
          _initialValues['photoThree'] = _photoThree;
        }
      });
      _checkIfHasChanges();
    }
  }

  bool _hasChanges() {
    for (final entry in _pendingChanges.entries) {
      final initialValue = _initialValues[entry.key] ?? false;
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

  void _initializeSwitchValues() {
    final orderState = context.read<OrderBloc>().state;
    if (orderState is OrderLoaded) {
      _updateSwitchValuesFromOrder(orderState.orderForCarusel);
    }
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

  @override
  void initState() {
    super.initState();
    if (widget.savedPendingChanges != null &&
        widget.savedPendingChanges!.isNotEmpty) {
      _pendingChanges = Map<String, bool>.from(widget.savedPendingChanges!);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSwitchValues();
      if (_pendingChanges.isNotEmpty) {
        setState(() {
          _pendingChanges.forEach((key, value) {
            switch (key) {
              case 'photoOne':
                _photoOne = value;
                break;
              case 'photoTwo':
                _photoTwo = value;
                break;
              case 'photoThree':
                _photoThree = value;
                break;
            }
          });
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkIfHasChanges();
        });
      }
      if (widget.onConfirmCallback != null) {
        widget.onConfirmCallback!(confirmChanges);
      }
    });
  }

  Map<String, bool> getPendingChanges() {
    return Map<String, bool>.from(_pendingChanges);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, orderState) {
        if (orderState is OrderLoaded) {
          _updateSwitchValuesFromOrder(orderState.orderForCarusel);
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<UserBloc>()),
        ],
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
                        BlocBuilder<ClientsBloc, ClientsState>(
                          builder: (context, clientState) {
                            bool showPhotoOne = false;
                            bool showPhotoTwo = false;
                            bool showPhotoThree = false;

                            if (clientState is ClientsLoaded &&
                                clientState.selectedClient != null) {
                              final orderAlbum =
                                  clientState.selectedClient!.orderAlbum;

                              if (orderAlbum == false) {
                                showPhotoThree =
                                    state.folderSettings.photoThree.show;
                              } else {
                                showPhotoOne =
                                    state.folderSettings.photoOne.show;
                                showPhotoTwo =
                                    state.folderSettings.photoTwo.show;
                                showPhotoThree =
                                    state.folderSettings.photoThree.show;
                              }
                            } else {
                              showPhotoOne = state.folderSettings.photoOne.show;
                              showPhotoTwo = state.folderSettings.photoTwo.show;
                              showPhotoThree =
                                  state.folderSettings.photoThree.show;
                            }

                            return Column(
                              children: [
                                if (showPhotoOne)
                                  Row(
                                    children: [
                                      Switch(
                                        value: _pendingChanges['photoOne'] ??
                                            _photoOne,
                                        onChanged: !_isOrderBlocked()
                                            ? (value) {
                                                setState(() {
                                                  _photoOne = value;
                                                });
                                                _updateOrder('photoOne', value);
                                              }
                                            : null,
                                      ),
                                      Text(
                                        _getDisplayName(
                                            state
                                                .folderSettings.photoOne.ruName,
                                            state
                                                .folderSettings.photoOne.price),
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                if (showPhotoTwo)
                                  Row(
                                    children: [
                                      Switch(
                                        value: _pendingChanges['photoTwo'] ??
                                            _photoTwo,
                                        onChanged: !_isOrderBlocked()
                                            ? (value) {
                                                setState(() {
                                                  _photoTwo = value;
                                                });
                                                _updateOrder('photoTwo', value);
                                              }
                                            : null,
                                      ),
                                      Text(
                                        _getDisplayName(
                                            state
                                                .folderSettings.photoTwo.ruName,
                                            state
                                                .folderSettings.photoTwo.price),
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                if (showPhotoThree)
                                  Row(
                                    children: [
                                      Switch(
                                        value: _pendingChanges['photoThree'] ??
                                            _photoThree,
                                        onChanged: !_isOrderBlocked()
                                            ? (value) {
                                                setState(() {
                                                  _photoThree = value;
                                                });
                                                _updateOrder(
                                                    'photoThree', value);
                                              }
                                            : null,
                                      ),
                                      Text(
                                        _getDisplayName(
                                            state.folderSettings.photoThree
                                                .ruName,
                                            state.folderSettings.photoThree
                                                .price),
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          },
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
      ),
    );
  }

  void _updateOrder(String formatName, bool value) {
    final initialValue = _initialValues[formatName] ?? false;

    setState(() {
      if (value == initialValue) {
        _pendingChanges.remove(formatName);
      } else {
        _pendingChanges[formatName] = value;
      }
    });

    widget.onPendingChangesChanged
        ?.call(Map<String, bool>.from(_pendingChanges));

    _checkIfHasChanges();

    if (widget.onChangesMade != null) {
      widget.onChangesMade!();
    }
  }

  void confirmChanges() {
    final clientState = context.read<ClientsBloc>().state;
    if (clientState is ClientsLoaded && clientState.selectedClient != null) {
      final orderBloc = context.read<OrderBloc>();

      for (final entry in _pendingChanges.entries) {
        final formatName = entry.key;
        final value = entry.value;

        if (['photoOne', 'photoTwo', 'photoThree'].contains(formatName)) {
          final event = UpdateSingleSelectionOrder(
            fileId: widget.imageId.toString(),
            clientId: clientState.selectedClient!.id.toString(),
            folderId: widget.folderId.toString(),
            formatName: formatName,
            count: value ? '1' : '0',
          );
          orderBloc.add(event);
        } else {
          final event = UpdateOrder(
            fileId: widget.imageId.toString(),
            clientId: clientState.selectedClient!.id.toString(),
            folderId: widget.folderId.toString(),
            formatName: formatName,
            count: value ? '1' : '0',
          );
          orderBloc.add(event);
        }
      }

      setState(() {
        _initialValues.clear();
        _initialValues.addAll({
          'photoOne': _photoOne,
          'photoTwo': _photoTwo,
          'photoThree': _photoThree,
        });
        _pendingChanges.clear();
      });
      widget.onPendingChangesChanged?.call({});
      _checkIfHasChanges();
    }
  }

  String _getDisplayName(String? ruName, int? price) {
    String displayName = ruName ?? '';
    if (price != null && price != 0) {
      displayName += ' ($price ₽)';
    }
    return displayName;
  }
}
