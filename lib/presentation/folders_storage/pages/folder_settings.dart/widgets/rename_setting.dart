import 'package:flutter/material.dart';

class RenameSetting extends StatelessWidget {
  final String? settingName;
  final String? currentName;
  final int? price;
  final Function(String, String) onSave;
  final Function(String, String) onSavePrice;
  const RenameSetting({
    super.key,
    required this.settingName,
    required this.currentName,
    required this.price,
    required this.onSave,
    required this.onSavePrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: 'Изменить название поля',
          child: TextButton(
            child: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: Colors.grey,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String newName = currentName ?? '';
                  final controller = TextEditingController(text: newName);
                  return AlertDialog(
                    title: const Text('Введите новое название'),
                    content: TextField(
                      controller: controller,
                      onChanged: (value) {
                        newName = value;
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          onSave(settingName ?? '', newName);
                          Navigator.pop(context);
                        },
                        child: const Text('Сохранить'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        Tooltip(
          message: 'Добавить цену',
          child: TextButton(
            child: const Icon(
              Icons.attach_money_outlined,
              size: 20,
              color: Colors.grey,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String newPrice = price?.toString() ?? '';
                  final controller = TextEditingController(text: newPrice);
                  return AlertDialog(
                    title: const Text('Введите цену'),
                    content: TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Введите цену (например: 150 или 150.50)',
                      ),
                      onChanged: (value) {
                        if (_isValidPriceInput(value)) {
                          newPrice = value;
                        } else {
                          controller.text = newPrice;
                          controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: newPrice.length),
                          );
                        }
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          onSavePrice(settingName ?? '', newPrice);
                          Navigator.pop(context);
                        },
                        child: const Text('Сохранить'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isValidPriceInput(String value) {
    if (value.isEmpty) return true;

    final validChars = RegExp(r'^[0-9.,]+$');
    if (!validChars.hasMatch(value)) return false;

    final dotCount = value.split('.').length - 1;
    final commaCount = value.split(',').length - 1;

    if (dotCount > 1 || commaCount > 1) return false;

    if (value.startsWith('.') || value.startsWith(',')) return false;

    return true;
  }
}
