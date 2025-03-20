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
        splashRadius: 20,
        padding: EdgeInsets.zero,
        iconSize: 24,
        icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
        onPressed: () {
          onDelete(context);
        },
      ),
    );
  }
}
