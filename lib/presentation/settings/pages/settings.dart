import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_event.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';
import 'package:photo_app/entities/watermark/watermark_bloc.dart';
import 'package:photo_app/presentation/settings/pages/widgets/profile.dart';
import 'package:photo_app/presentation/settings/pages/widgets/settings_list.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc()..add(LoadUser())),
        BlocProvider(create: (context) => WatermarkBloc()),
      ],
      child: Scaffold(
        appBar: const AppBarCustom(
          title: 'Настройки',
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            if (userState is UserLoaded) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Profile(),
                    SettingsList(userId: userState.user.id.toString()),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
