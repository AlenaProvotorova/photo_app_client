import 'package:flutter/material.dart';
import 'package:photo_app/core/theme/app_images.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onPress;
  final bool showLeading;
  const AppBarCustom(
      {super.key, required this.title, this.onPress, this.showLeading = false});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.headlineMedium,
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      automaticallyImplyLeading: showLeading,
      leading: showLeading
          ? IconButton(
              onPressed: onPress,
              icon: AppImages.arrowBackImage,
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
