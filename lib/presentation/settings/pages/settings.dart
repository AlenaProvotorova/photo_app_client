import 'package:flutter/material.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/presentation/settings/pages/widgets/profile.dart';
import 'package:photo_app/presentation/settings/pages/widgets/settings_list.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarCustom(
        title: 'Настройки',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Profile(),
            SettingsList(),
          ],
        ),
      ),
    );
  }
}
