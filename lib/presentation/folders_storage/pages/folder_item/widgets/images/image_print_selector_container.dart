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

class ImagePrintSelectorContainer extends StatelessWidget {
  final int imageId;
  final int folderId;
  ImagePrintSelectorContainer({
    super.key,
    required this.imageId,
    required this.folderId,
  });

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
      if (orderState is! OrderLoaded) {
        return 0;
      }

      final orders = orderState.orderForCarusel[imageId.toString()];
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
                  // Проверяем, что клиент выбран и заказы загружены
                  if (clientsState is! ClientsLoaded ||
                      clientsState.selectedClient == null) {
                    return const SizedBox.shrink();
                  }

                  if (orderState is! OrderLoaded) {
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
                            imageId: imageId,
                            folderId: folderId,
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
