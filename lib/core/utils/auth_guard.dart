import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_event.dart';
import 'package:photo_app/core/utils/token_storage.dart';
import 'package:photo_app/data/auth/services/auto_login_service.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuthStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data == true) {
          return BlocProvider(
            create: (context) => UserBloc()..add(LoadUser()),
            child: child,
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<bool> _checkAuthStatus() async {
    final token = await TokenStorage.loadToken();
    if (token != null && token.isNotEmpty) {
      return true;
    }

    final autoLoginResult = await AutoLoginService.tryAutoLogin();
    return autoLoginResult;
  }
}
