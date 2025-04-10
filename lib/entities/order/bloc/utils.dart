import 'package:photo_app/data/order/models/order.dart';

class OrderUtils {
  static Map<String, Map<String, dynamic>> getFullOrderForTable(data) {
    final fullOrderForTable = <String, Map<String, dynamic>>{};
    for (final item in data) {
      try {
        final order = Order.fromJson(item);
        final fileIdentifier = '${order.file.id}_${order.client.name}';
        final fileName = order.file.originalName;
        final clientName = order.client.name;

        if (!fullOrderForTable.containsKey(fileIdentifier)) {
          fullOrderForTable[fileIdentifier] = {
            'fileName': fileName,
            'clientName': clientName,
            'sizes': <String, int>{},
          };
        }
        fullOrderForTable[fileIdentifier]!['sizes'][order.size.name] =
            order.count;
      } catch (e) {}
    }
    return fullOrderForTable;
  }

  static Map<String, Map<String, int>> getFullOrderForCarusel(data) {
    final Map<String, Map<String, int>> orderForCarusel = {};
    for (final item in data) {
      try {
        final order = Order.fromJson(item);
        final fileId = order.file.id.toString();
        final sizeName = order.size.name;
        final count = order.count;
        if (!orderForCarusel.containsKey(fileId)) {
          orderForCarusel[fileId] = {};
        }
        orderForCarusel[fileId]![sizeName] = count;
      } catch (e) {}
    }
    return orderForCarusel;
  }

  static Map<String, Map<String, dynamic>> getFullOrderForSorting(data) {
    final fullOrderForSorting = <String, Map<String, dynamic>>{};
    for (final item in data) {
      try {
        final order = Order.fromJson(item);
        final clientName = order.client.name;
        final sizeName = order.size.name;
        final fileName = order.file.originalName;
        if (!fullOrderForSorting.containsKey(clientName)) {
          fullOrderForSorting[clientName] = {};
        }
        if (!fullOrderForSorting[clientName]!.containsKey(sizeName)) {
          fullOrderForSorting[clientName]![sizeName] = [];
        }
        fullOrderForSorting[clientName]![sizeName]!.add(fileName);
      } catch (e) {}
    }
    return fullOrderForSorting;
  }
}
