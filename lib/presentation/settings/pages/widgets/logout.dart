import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_app/core/utils/token_storage.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
        onTap: () {
          TokenStorage.deleteToken();
          context.go('/');
        },
        title: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              'Выйти из профиля',
              style: theme.textTheme.bodyMedium,
            )
          ],
        ));
  }
}
