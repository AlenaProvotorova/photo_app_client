import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_print_selector.dart';

class ImagePrintSelectorContainer extends StatefulWidget {
  final int imageId;
  final int folderId;
  ImagePrintSelectorContainer({
    super.key,
    required this.imageId,
    required this.folderId,
  });

  @override
  State<ImagePrintSelectorContainer> createState() =>
      _ImagePrintSelectorContainerState();
}

class _ImagePrintSelectorContainerState
    extends State<ImagePrintSelectorContainer> {
  Map<String, Map<String, int>>? _cachedOrderData;

  final List<String> sizesNames = [
    'sizeOne',
    'sizeTwo',
    'sizeThree',
  ];

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

                  if (orderState is! OrderLoaded && _cachedOrderData == null) {
                    return const SizedBox.shrink();
                  }

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: sizesNames.map((sizeName) {
                        if (settingsState is FolderSettingsLoaded) {
                          if (!settingsState.folderSettings
                              .getShowProperty(sizeName)) {
                            return const SizedBox.shrink();
                          }
                          return ImagePrintSelector(
                            size: settingsState.folderSettings
                                .getRuNameProperty(sizeName),
                            formatName: sizeName,
                            imageId: widget.imageId,
                            folderId: widget.folderId,
                            defaultQuantity:
                                getDefaultQuantity(sizeName, orderState),
                          );
                        }
                        return const SizedBox.shrink();
                      }).toList(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
