import 'package:flutter/material.dart';
import 'package:photo_app/core/theme/app_images.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onPress;
  final bool showLeading;
  final List<Widget>? actions;
  const AppBarCustom(
      {super.key,
      required this.title,
      this.onPress,
      this.showLeading = false,
      this.actions});
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
      actions: actions,
      leading: showLeading
          ? IconButton(
              onPressed: onPress,
              icon: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
                child: AppImages.arrowBackImage,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
