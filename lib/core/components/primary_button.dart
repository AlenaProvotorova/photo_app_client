import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPress;
  final bool disabled;
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPress,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: disabled ? Colors.grey : theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12)),
      child: IntrinsicWidth(
        child: TextButton(
          onPressed: onPress,
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
