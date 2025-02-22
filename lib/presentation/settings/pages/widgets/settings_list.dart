import 'package:flutter/material.dart';
import 'package:photo_app/presentation/settings/pages/widgets/logout.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          Logout(),
          Divider(),
        ],
      ),
    );
  }
}
