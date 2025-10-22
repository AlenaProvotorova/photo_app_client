import 'package:flutter/material.dart';

class ConfirmationButton extends StatelessWidget {
  final bool hasUnconfirmedChanges;
  final VoidCallback onConfirm;
  final String? label;

  const ConfirmationButton({
    super.key,
    required this.hasUnconfirmedChanges,
    required this.onConfirm,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: hasUnconfirmedChanges ? onConfirm : null,
        icon: const Icon(Icons.check),
        label: Text(label ?? 'Подтвердить выбор'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
