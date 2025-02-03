import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/bloc/user_block_bloc.dart';
import 'package:photo_app/components/app_bar_custom.dart';
import 'package:photo_app/storage/token_storage.dart';
import 'package:photo_app/theme/images.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    UserBlockBloc().add(FetchUser());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const AppBarCustom(
        title: 'Настройки',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: ListView(
          children: [
            _profile(),
            TextButton(
                onPressed: () {
                  TokenStorage.deleteToken();
                  Navigator.of(context).pushNamed('/');
                },
                child: Row(
                  children: [
                    logoutImage,
                    const SizedBox(width: 8),
                    Text(
                      'Выйти из профиля',
                      style: theme.textTheme.titleMedium,
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget _profile() {
    return BlocBuilder<UserBlockBloc, UserBlockState>(
        builder: (context, state) {
      print('state: $state');
      if (state is UserBlockSuccess) {
        return Center(
          child: Column(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.blue[100],
                ),
                child: const Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                // state ?? 'Нет данных',
                'yy',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
