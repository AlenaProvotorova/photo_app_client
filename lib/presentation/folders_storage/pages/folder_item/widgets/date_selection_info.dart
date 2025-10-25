import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';
import 'package:intl/intl.dart';

class DateSelectionInfo extends StatelessWidget {
  final String folderId;

  const DateSelectionInfo({
    super.key,
    required this.folderId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<FolderSettingsBloc, FolderSettingsState>(
      builder: (context, folderSettingsState) {
        if (folderSettingsState is FolderSettingsLoaded) {
          final dateSelectTo = folderSettingsState.folderSettings.dateSelectTo;

          if (dateSelectTo == null) {
            return const SizedBox.shrink();
          }

          final now = DateTime.now();
          final daysUntilDeadline = dateSelectTo.difference(now).inDays;

          Color backgroundColor;
          if (daysUntilDeadline < 0) {
            backgroundColor = theme.colorScheme.error.withOpacity(0.1);
          } else if (daysUntilDeadline <= 3) {
            backgroundColor = theme.colorScheme.error.withOpacity(0.1);
          } else {
            backgroundColor = theme.colorScheme.primaryContainer;
          }

          final dateFormatter = DateFormat('dd.MM.yyyy');
          final formattedDate = dateFormatter.format(dateSelectTo);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: daysUntilDeadline <= 3
                    ? theme.colorScheme.error.withOpacity(0.3)
                    : theme.colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: daysUntilDeadline <= 3
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Необходимо выбрать фото до $formattedDate. После этой даты выбор будет недоступен',
                    style: TextStyle(
                      color: daysUntilDeadline <= 3
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  static bool isOrderBlocked(BuildContext context) {
    final folderSettingsState = context.read<FolderSettingsBloc>().state;
    final userState = context.read<UserBloc>().state;

    if (userState is UserLoaded && userState.user.isAdmin) {
      return false;
    }

    if (folderSettingsState is FolderSettingsLoaded) {
      final dateSelectTo = folderSettingsState.folderSettings.dateSelectTo;

      if (dateSelectTo == null) {
        return false;
      }

      final now = DateTime.now();
      final daysUntilDeadline = dateSelectTo.difference(now).inDays;

      return daysUntilDeadline < 0;
    }

    return false;
  }
}
