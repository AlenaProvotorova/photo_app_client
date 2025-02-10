import 'package:flutter/material.dart';
import 'package:photo_app/presentation/auth/pages/login.dart';
import 'package:photo_app/core/utils/token_storage.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: TokenStorage.loadToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data.toString().isNotEmpty) {
          return child;
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
