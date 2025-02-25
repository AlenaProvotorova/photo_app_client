import 'package:flutter/material.dart';

class AddClientField extends StatelessWidget {
  final TextEditingController controllerName;
  final void Function() onSubmit;
  const AddClientField(
      {super.key, required this.controllerName, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controllerName,
            decoration: const InputDecoration(
              hintText: 'Введите имя и фамилию',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => onSubmit(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onSubmit,
          child: const Text('Добавить', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
