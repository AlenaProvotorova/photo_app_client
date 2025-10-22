import 'package:flutter/material.dart';
import 'package:photo_app/data/clients/models/client.dart';

class OrderTable extends StatelessWidget {
  final Map<String, dynamic> fullOrderForTable;
  final List<Map<String, dynamic>> sizes;
  final List<Map<String, dynamic>> photos;
  final ThemeData theme;
  final List<Client> clients;
  final String digitalPhotoName;
  final int digitalPhotoPrice;

  const OrderTable({
    super.key,
    required this.fullOrderForTable,
    required this.sizes,
    required this.photos,
    required this.theme,
    required this.clients,
    required this.digitalPhotoName,
    required this.digitalPhotoPrice,
  });

  @override
  Widget build(BuildContext context) {
    const columnSpacing = 0;
    const horizontalPadding = 16;
    const horizontalMargin = 16;

    final columnCount = 2 + sizes.length + photos.length + 1;
    const fixedColumnWidth = 120.0;
    const firstColumnWidth = 240.0;
    final tableWidth = firstColumnWidth + (columnCount - 1) * fixedColumnWidth;

    final nestedData = _getNestedRows();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
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
                          width: firstColumnWidth,
                          child: Text(
                            'В общую',
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
                      DataColumn(
                        label: SizedBox(
                          width: fixedColumnWidth,
                          child: Text(
                            'Стоимость',
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                    rows: nestedData.rows,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.orange[300]!,
            ),
          ),
          child: Text(
            'ОБЩИЙ ИТОГ: ${nestedData.grandTotal.toStringAsFixed(0)} ₽',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.orange[800],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  ({List<DataRow> rows, double grandTotal}) _getNestedRows() {
    final List<DataRow> rows = [];

    final Map<String, List<MapEntry<String, dynamic>>> groupedOrders = {};

    for (final entry in fullOrderForTable.entries) {
      final clientName = entry.value['clientName']?.toString() ?? '';
      if (!groupedOrders.containsKey(clientName)) {
        groupedOrders[clientName] = [];
      }
      groupedOrders[clientName]!.add(entry);
    }

    final sortedClientNames = groupedOrders.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    double grandTotal = 0.0;

    for (final clientName in sortedClientNames) {
      final clientOrders = groupedOrders[clientName]!;
      final client = clients.firstWhere(
        (c) => c.name == clientName,
        orElse: () => Client(
            id: 0,
            name: clientName,
            folderId: 0,
            orderDigital: false,
            orderAlbum: false),
      );

      rows.add(_buildClientHeaderRow(client));

      double clientTotal = 0.0;
      for (final orderEntry in clientOrders) {
        final orderRow = _buildOrderRow(orderEntry.value);
        rows.add(orderRow);
        clientTotal += _calculateRowTotal(orderEntry.value);
      }

      if (client.orderDigital && digitalPhotoPrice > 0) {
        rows.add(_buildDigitalPhotoRow());
        clientTotal += digitalPhotoPrice;
      }

      rows.add(_buildClientTotalRow(client, clientTotal));
      grandTotal += clientTotal;
    }

    return (rows: rows, grandTotal: grandTotal);
  }

  DataRow _buildClientHeaderRow(Client client) {
    return DataRow(
      color: WidgetStateProperty.all(Colors.grey[100]),
      cells: [
        DataCell(
          Text(
            client.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...List.generate(
            photos.length + sizes.length, (index) => const DataCell(Text(''))),
        const DataCell(Text('')),
      ],
    );
  }

  DataRow _buildOrderRow(Map<String, dynamic> orderData) {
    double rowTotal = _calculateRowTotal(orderData);

    return DataRow(
      cells: [
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120.0),
            child: Tooltip(
              message: orderData['fileName'],
              child: Text(
                orderData['fileName'],
                style: theme.textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        ...photos.map(
          (photo) => DataCell(
            _buildPhotoCell(
              orderData['sizes']?[photo['key']],
              theme,
            ),
          ),
        ),
        ...sizes.map(
          (size) => DataCell(
            _buildSizeCell(
              orderData['sizes'][size['key']],
              theme,
            ),
          ),
        ),
        DataCell(
          Text(
            rowTotal > 0 ? '${rowTotal.toStringAsFixed(0)} ₽' : '',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: rowTotal > 0 ? Colors.green[700] : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildDigitalPhotoRow() {
    return DataRow(
      color: WidgetStateProperty.all(Colors.purple[50]),
      cells: [
        DataCell(
          Text(
            '+ все фото в цифровом виде',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.purple[700],
            ),
          ),
        ),
        ...List.generate(
            photos.length + sizes.length, (index) => const DataCell(Text(''))),
        DataCell(
          Text(
            '${digitalPhotoPrice.toStringAsFixed(0)} ₽',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.purple[700],
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildClientTotalRow(Client client, double total) {
    return DataRow(
      color: WidgetStateProperty.all(Colors.blue[50]),
      cells: [
        const DataCell(Text('')),
        ...List.generate(
            photos.length + sizes.length, (index) => const DataCell(Text(''))),
        DataCell(
          Text(
            'ИТОГО: ${total.toStringAsFixed(0)} ₽',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoCell(dynamic value, ThemeData theme) {
    final int count =
        value is int ? value : (int.tryParse(value?.toString() ?? '0') ?? 0);

    if (count == 1) {
      return const Icon(
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

  Widget _buildSizeCell(dynamic value, ThemeData theme) {
    final int count =
        value is int ? value : (int.tryParse(value?.toString() ?? '0') ?? 0);

    if (count > 0) {
      return Text(
        count.toString(),
        style: theme.textTheme.labelLarge,
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

  double _calculateRowTotal(Map<String, dynamic> orderData) {
    double total = 0.0;

    for (final photo in photos) {
      final count = orderData['sizes']?[photo['key']] ?? 0;
      final price = photo['price'] ?? 0;
      if (count is int && count > 0) {
        total += count * price;
      }
    }

    for (final size in sizes) {
      final count = orderData['sizes']?[size['key']] ?? 0;
      final price = size['price'] ?? 0;
      if (count is int && count > 0) {
        total += count * price;
      }
    }

    return total;
  }
}
