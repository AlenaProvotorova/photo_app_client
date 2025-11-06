import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_app/core/utils/token_storage.dart';
import 'package:photo_app/data/auth/services/login_data_service.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    await TokenStorage.deleteToken();
    await LoginDataService.clearSavedLoginData();
    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          return ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 600),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: theme.colorScheme.primaryContainer,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.user.name,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.user.email,
                      style: theme.textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _handleLogout(context),
                  icon: Icon(
                    Icons.logout,
                    color: theme.colorScheme.error,
                  ),
                  tooltip: 'Выйти из профиля',
                ),
              ],
            ),
          );
        } else if (state is UserError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('User not found'));
      },
    );
  }
}
