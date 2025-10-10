import 'package:flutter/material.dart';

class OrderTable extends StatelessWidget {
  final Map<String, dynamic> fullOrderForTable;
  final List<Map<String, dynamic>> sizes;
  final List<Map<String, dynamic>> photos;
  final ThemeData theme;

  const OrderTable({
    super.key,
    required this.fullOrderForTable,
    required this.sizes,
    required this.photos,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    const columnSpacing = 0;
    const horizontalPadding = 16;
    const horizontalMargin = 16;

    final columnCount = 2 + sizes.length + photos.length;
    const fixedColumnWidth = 120.0; // Фиксированная ширина столбца
    final tableWidth = columnCount * fixedColumnWidth;

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
              rows: _getSortedRows(),
            ),
          ),
        ),
      ),
    );
  }

  List<DataRow> _getSortedRows() {
    // Преобразуем Map в список записей и сортируем по имени клиента
    final sortedEntries = fullOrderForTable.entries.toList()
      ..sort((a, b) {
        final clientNameA = a.value['clientName']?.toString() ?? '';
        final clientNameB = b.value['clientName']?.toString() ?? '';
        return clientNameA.toLowerCase().compareTo(clientNameB.toLowerCase());
      });

    return sortedEntries.map((entry) {
      final details = entry.value;

      return DataRow(cells: [
        DataCell(
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 120.0),
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
            details['sizes'][size['key']]?.toString() ?? '0',
            style: theme.textTheme.labelLarge,
          )),
        ),
      ]);
    }).toList();
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
