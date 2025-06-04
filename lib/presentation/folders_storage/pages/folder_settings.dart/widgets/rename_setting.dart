import 'package:flutter/material.dart';

class RenameSetting extends StatelessWidget {
  final String? settingName;
  final Function(String, String) onSave;
  const RenameSetting({
    super.key,
    required this.settingName,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'Изменить',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            String newName = '';
            return AlertDialog(
              title: const Text('Изменить'),
              content: TextField(
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
    );
  }
}
