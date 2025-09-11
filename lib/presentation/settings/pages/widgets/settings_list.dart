import 'package:flutter/material.dart';
import 'package:photo_app/presentation/settings/pages/widgets/watermark/upload_watermark.dart';
import 'package:photo_app/presentation/settings/pages/widgets/logout.dart';

class SettingsList extends StatelessWidget {
  final String userId;
  const SettingsList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          UploadWatermarkWidget(userId: userId),
          const SizedBox(height: 32),
          const Logout(),
        ],
      ),
    );
  }
}
