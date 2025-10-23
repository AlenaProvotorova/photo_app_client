import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_app/core/utils/token_storage.dart';
import 'package:photo_app/data/auth/services/login_data_service.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          await TokenStorage.deleteToken();
          await LoginDataService.clearSavedLoginData();
          context.go('/login');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.error,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
        ),
        child: Text(
          'Выйти из профиля',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
