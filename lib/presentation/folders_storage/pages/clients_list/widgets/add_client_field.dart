import 'package:flutter/material.dart';

class AddClientField extends StatelessWidget {
  final TextEditingController controllerName;
  final void Function() onSubmit;
  const AddClientField(
      {super.key, required this.controllerName, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controllerName,
                decoration: InputDecoration(
                  hintText: 'Введите имя и фамилию',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE4E4E4)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE4E4E4)),
                  ),
                  hintStyle: theme.textTheme.titleSmall,
                ),
                onSubmitted: (_) => onSubmit(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onSubmit,
              child:
                  const Text('Добавить', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        Text(
          'Вы можете добавить несколько клиентов, разделяя их запятыми',
          style: theme.textTheme.titleSmall,
        ),
      ],
    );
  }
}
