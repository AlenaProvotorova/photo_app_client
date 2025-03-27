import 'package:flutter/material.dart';

class AddDescription extends StatelessWidget {
  final String descriptionName;
  final Function(String, String) onSave;
  const AddDescription({
    super.key,
    required this.descriptionName,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'Добавить описание',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            String description = '';
            return AlertDialog(
              title: const Text('Добавить описание'),
              content: TextField(
                decoration: const InputDecoration(
                  hintText: 'Введите описание...',
                ),
                onChanged: (value) {
                  description = value;
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
                    onSave(descriptionName, description);
                    Navigator.pop(context);
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
