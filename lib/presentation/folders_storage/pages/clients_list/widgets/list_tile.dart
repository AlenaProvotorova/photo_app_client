import 'package:flutter/material.dart';

class SurnameListTile extends StatelessWidget {
  final String name;
  final void Function(BuildContext context) onDelete;
  const SurnameListTile(
      {super.key, required this.name, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          onDelete(context);
        },
      ),
    );
  }
}
