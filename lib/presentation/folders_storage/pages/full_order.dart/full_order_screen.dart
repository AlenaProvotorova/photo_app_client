import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as router;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_bloc.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_event.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_state.dart';

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
          create: (context) => SizesBloc()..add(LoadSizes()),
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
              return BlocBuilder<SizesBloc, SizesState>(
                builder: (context, sizesState) {
                  if (sizesState is SizesLoaded) {
                    const columnSpacing = 0;
                    const horizontalPadding = 16;
                    const horizontalMargin = 16;

                    final columnCount = 2 + sizesState.sizes.length;
                    final screenWidth = MediaQuery.of(context).size.width -
                        horizontalPadding * 2;
                    final columnWidth = screenWidth / columnCount;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding.toDouble(),
                        ),
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
                                width: columnWidth,
                                child: Text(
                                  'В общую',
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: columnWidth,
                                child: Text(
                                  'Список имен',
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ),
                            ...sizesState.sizes.map(
                              (size) => DataColumn(
                                label: SizedBox(
                                  width: columnWidth,
                                  child: Text(
                                    size.name,
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
                                            maxWidth: columnWidth),
                                        child: Tooltip(
                                          message: details['fileName'],
                                          child: Text(
                                            details['fileName'],
                                            style: theme.textTheme.labelLarge,
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
                                    ...sizesState.sizes.map(
                                      (size) => DataCell(Text(
                                        details['sizes'][size.name]
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
