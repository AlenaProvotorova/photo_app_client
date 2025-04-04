import 'package:flutter/material.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/widgets/actions/popup_menu_action.dart';

class PopupMenuButtonWidget extends StatelessWidget {
  final List<PopupMenuAction> actions;

  const PopupMenuButtonWidget({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton(
      tooltip: 'Действия',
      icon: const Icon(
        Icons.more_vert,
        color: Colors.black,
      ),
      splashRadius: 20,
      padding: EdgeInsets.zero,
      iconSize: 24,
      itemBuilder: (context) => actions.map((action) {
        return PopupMenuItem(
          value: action,
          child: Text(
            action.title,
            style: theme.textTheme.labelLarge,
          ),
        );
      }).toList(),
      onSelected: (PopupMenuAction action) {
        action.onTap();
      },
    );
  }
}
