import 'package:flutter/material.dart';

class AddClientField extends StatefulWidget {
  final TextEditingController controllerName;
  final void Function() onSubmit;
  const AddClientField(
      {super.key, required this.controllerName, required this.onSubmit});

  @override
  State<AddClientField> createState() => _AddClientFieldState();
}

class _AddClientFieldState extends State<AddClientField> {
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _isButtonEnabled = widget.controllerName.text.trim().isNotEmpty;
    widget.controllerName.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controllerName.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final isNotEmpty = widget.controllerName.text.trim().isNotEmpty;
    if (_isButtonEnabled != isNotEmpty) {
      setState(() {
        _isButtonEnabled = isNotEmpty;
      });
    }
  }

  void _onSubmit() {
    if (_isButtonEnabled) {
      widget.onSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controllerName,
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
                onSubmitted: (_) => _onSubmit(),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _onSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled
                      ? theme.colorScheme.primary
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Добавить'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
