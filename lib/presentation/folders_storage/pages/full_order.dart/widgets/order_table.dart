import 'package:flutter/material.dart';
import 'package:photo_app/data/clients/models/client.dart';
import 'dart:math' as math;

class OrderTable extends StatefulWidget {
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
  State<OrderTable> createState() => _OrderTableState();
}

class _OrderTableState extends State<OrderTable> {
  late ScrollController _headerScrollController;
  late ScrollController _contentScrollController;

  @override
  void initState() {
    super.initState();
    _headerScrollController = ScrollController();
    _contentScrollController = ScrollController();

    _contentScrollController.addListener(() {
      if (_headerScrollController.hasClients &&
          _contentScrollController.hasClients) {
        if (_headerScrollController.offset != _contentScrollController.offset) {
          _headerScrollController.jumpTo(_contentScrollController.offset);
        }
      }
    });

    _headerScrollController.addListener(() {
      if (_headerScrollController.hasClients &&
          _contentScrollController.hasClients) {
        if (_contentScrollController.offset != _headerScrollController.offset) {
          _contentScrollController.jumpTo(_headerScrollController.offset);
        }
      }
    });
  }

  @override
  void dispose() {
    _headerScrollController.dispose();
    _contentScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nestedData = _getNestedRows();

    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth;

    final double contentWidth = math.max(1200.0, availableWidth);

    final firstColumnWidth = contentWidth * 0.2;

    final costColumnWidth = contentWidth * 0.15;

    final otherColumnsCount = widget.photos.length + widget.sizes.length;
    final otherColumnsTotalWidth = contentWidth * 0.65;

    final otherColumnWidth = otherColumnsCount > 0
        ? otherColumnsTotalWidth / otherColumnsCount
        : 0.0;

    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                    ),
                    child: SingleChildScrollView(
                      controller: _headerScrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: SizedBox(
                        width: contentWidth,
                        child: Table(
                          border: TableBorder.all(
                            color: const Color(0xFFE4E4E4),
                            width: 1,
                          ),
                          columnWidths: {
                            0: FixedColumnWidth(firstColumnWidth),
                            ...Map.fromIterable(
                              List.generate(
                                  widget.photos.length, (index) => index + 1),
                              key: (index) => index + 1,
                              value: (index) =>
                                  FixedColumnWidth(otherColumnWidth),
                            ),
                            ...Map.fromIterable(
                              List.generate(widget.sizes.length,
                                  (index) => index + widget.photos.length + 1),
                              key: (index) => index + widget.photos.length + 1,
                              value: (index) =>
                                  FixedColumnWidth(otherColumnWidth),
                            ),
                            widget.photos.length + widget.sizes.length + 1:
                                FixedColumnWidth(costColumnWidth),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                              ),
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'В общую',
                                    style: widget.theme.textTheme.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 1,
                                  ),
                                ),
                                ...widget.photos.map(
                                  (photo) => Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          photo['name'],
                                          style: widget
                                              .theme.textTheme.titleMedium,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          maxLines: 1,
                                        ),
                                        if (photo['price'] != null &&
                                            photo['price'] > 0)
                                          Text(
                                            '${photo['price']} ₽',
                                            style: widget
                                                .theme.textTheme.titleMedium
                                                ?.copyWith(
                                              fontSize: (widget
                                                          .theme
                                                          .textTheme
                                                          .titleMedium
                                                          ?.fontSize ??
                                                      16) *
                                                  0.7,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            maxLines: 1,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                ...widget.sizes.map(
                                  (size) => Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          size['name'].toString().split(' (')[
                                              0], // Убираем цену из названия
                                          style: widget
                                              .theme.textTheme.titleMedium,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          maxLines: 1,
                                        ),
                                        if (size['price'] != null &&
                                            size['price'] > 0)
                                          Text(
                                            '${size['price']} ₽',
                                            style: widget
                                                .theme.textTheme.titleMedium
                                                ?.copyWith(
                                              fontSize: (widget
                                                          .theme
                                                          .textTheme
                                                          .titleMedium
                                                          ?.fontSize ??
                                                      16) *
                                                  0.7,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            maxLines: 1,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'Стоимость',
                                    style: widget.theme.textTheme.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 66,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        controller: _contentScrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        child: SizedBox(
                          width: contentWidth,
                          child: Table(
                            border: TableBorder.all(
                              color: const Color(0xFFE4E4E4),
                              width: 1,
                            ),
                            columnWidths: {
                              0: FixedColumnWidth(firstColumnWidth),
                              ...Map.fromIterable(
                                List.generate(
                                    widget.photos.length, (index) => index + 1),
                                key: (index) => index + 1,
                                value: (index) =>
                                    FixedColumnWidth(otherColumnWidth),
                              ),
                              ...Map.fromIterable(
                                List.generate(
                                    widget.sizes.length,
                                    (index) =>
                                        index + widget.photos.length + 1),
                                key: (index) =>
                                    index + widget.photos.length + 1,
                                value: (index) =>
                                    FixedColumnWidth(otherColumnWidth),
                              ),
                              widget.photos.length + widget.sizes.length + 1:
                                  FixedColumnWidth(costColumnWidth),
                            },
                            children: nestedData.rows.map((dataRow) {
                              return TableRow(
                                decoration: dataRow.color != null
                                    ? BoxDecoration(
                                        color: dataRow.color!
                                            .resolve({})?.withOpacity(0.1))
                                    : null,
                                children: dataRow.cells.map((cell) {
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    child: cell.child,
                                  );
                                }).toList(),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
            style: widget.theme.textTheme.titleLarge?.copyWith(
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

    for (final entry in widget.fullOrderForTable.entries) {
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
      final client = widget.clients.firstWhere(
        (c) => c.name == clientName,
        orElse: () => Client(
            id: 0,
            name: clientName,
            folderId: 0,
            orderDigital: false,
            orderAlbum: false),
      );

      rows.add(_buildClientHeaderRow(client, widget.theme));

      double clientTotal = 0.0;
      for (final orderEntry in clientOrders) {
        final orderRow = _buildOrderRow(orderEntry.value, widget.theme);
        rows.add(orderRow);
        clientTotal += _calculateRowTotal(orderEntry.value);
      }

      if (client.orderDigital) {
        rows.add(_buildDigitalPhotoRow(widget.theme));
        clientTotal += widget.digitalPhotoPrice;
      }

      rows.add(_buildClientTotalRow(client, clientTotal, widget.theme));
      grandTotal += clientTotal;
    }

    return (rows: rows, grandTotal: grandTotal);
  }

  DataRow _buildClientHeaderRow(Client client, ThemeData theme) {
    return DataRow(
      color: WidgetStateProperty.all(Colors.grey[100]),
      cells: [
        DataCell(
          Text(
            client.name,
            style: widget.theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...List.generate(widget.photos.length + widget.sizes.length,
            (index) => const DataCell(Text(''))),
        const DataCell(Text('')),
      ],
    );
  }

  DataRow _buildOrderRow(Map<String, dynamic> orderData, ThemeData theme) {
    double rowTotal = _calculateRowTotal(orderData);

    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width:
                _calculateMaxFileNameWidth(), // Используем вычисленную ширину
            child: Tooltip(
              message: orderData['fileName'],
              child: Text(
                orderData['fileName'],
                style: widget.theme.textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
              ),
            ),
          ),
        ),
        ...widget.photos.map(
          (photo) => DataCell(
            _buildPhotoCell(
              orderData['sizes']?[photo['key']],
              widget.theme,
            ),
          ),
        ),
        ...widget.sizes.map(
          (size) => DataCell(
            _buildSizeCell(
              orderData['sizes'][size['key']],
              widget.theme,
            ),
          ),
        ),
        DataCell(
          Text(
            rowTotal > 0 ? '${rowTotal.toStringAsFixed(0)} ₽' : '',
            style: widget.theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: rowTotal > 0 ? Colors.green[700] : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildDigitalPhotoRow(ThemeData theme) {
    return DataRow(
      color: WidgetStateProperty.all(Colors.purple[200]),
      cells: [
        DataCell(
          Text(
            '+ все фото в цифровом виде',
            style: widget.theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.purple[700],
            ),
          ),
        ),
        ...List.generate(widget.photos.length + widget.sizes.length,
            (index) => const DataCell(Text(''))),
        DataCell(
          Text(
            widget.digitalPhotoPrice > 0
                ? '${widget.digitalPhotoPrice.toStringAsFixed(0)} ₽'
                : '',
            style: widget.theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.purple[700],
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildClientTotalRow(Client client, double total, ThemeData theme) {
    return DataRow(
      color: WidgetStateProperty.all(Colors.blue[200]),
      cells: [
        const DataCell(Text('')),
        ...List.generate(widget.photos.length + widget.sizes.length,
            (index) => const DataCell(Text(''))),
        DataCell(
          Text(
            'ИТОГО: ${total.toStringAsFixed(0)} ₽',
            style: widget.theme.textTheme.titleMedium?.copyWith(
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
        style: widget.theme.textTheme.labelLarge?.copyWith(
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
        style: widget.theme.textTheme.labelLarge,
      );
    } else {
      return Text(
        '-',
        style: widget.theme.textTheme.labelLarge?.copyWith(
          color: Colors.grey,
        ),
      );
    }
  }

  double _calculateRowTotal(Map<String, dynamic> orderData) {
    double total = 0.0;

    for (final photo in widget.photos) {
      final count = orderData['sizes']?[photo['key']] ?? 0;
      final price = photo['price'] ?? 0;
      if (count is int && count > 0) {
        total += count * price;
      }
    }

    for (final size in widget.sizes) {
      final count = orderData['sizes']?[size['key']] ?? 0;
      final price = size['price'] ?? 0;
      if (count is int && count > 0) {
        total += count * price;
      }
    }

    return total;
  }

  double _calculateMaxFileNameWidth() {
    double maxWidth = 0.0;

    for (final entry in widget.fullOrderForTable.entries) {
      final fileName = entry.value['fileName']?.toString() ?? '';
      if (fileName.isNotEmpty) {
        final textWidth = fileName.length * 8.0;
        maxWidth = math.max(maxWidth, textWidth);
      }
    }

    return maxWidth;
  }
}
