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
      child: ElevatedButton(
        onPressed: hasUnconfirmedChanges ? onConfirm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  color: hasUnconfirmedChanges ? Colors.white : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  label ?? 'Подтвердить выбор',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: hasUnconfirmedChanges ? Colors.white : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'необходимо для перехода к следующему фото',
              style: TextStyle(
                fontSize: 12,
                color: hasUnconfirmedChanges ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
