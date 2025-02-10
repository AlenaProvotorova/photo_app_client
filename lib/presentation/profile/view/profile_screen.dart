import 'package:flutter/material.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarCustom(
        title: 'Пользователь',
      ),
    );
  }
}
