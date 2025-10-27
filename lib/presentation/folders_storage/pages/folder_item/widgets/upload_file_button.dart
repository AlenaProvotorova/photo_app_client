import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';

class UploadFileButton extends StatelessWidget {
  final void Function(BuildContext context) pickImages;
  final void Function(BuildContext context)? onDeleteAll;
  const UploadFileButton({
    super.key,
    required this.pickImages,
    this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return state.user.isAdmin
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            pickImages(context);
                          },
                          child: const Text('Загрузить фотографии',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      if (onDeleteAll != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor:
                                theme.colorScheme.error.withOpacity(0.1),
                            side: BorderSide(color: theme.colorScheme.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => onDeleteAll!(context),
                          icon: Icon(
                            Icons.delete_outline,
                            color: theme.colorScheme.error,
                          ),
                          tooltip: 'Удалить все файлы',
                        ),
                      ],
                    ],
                  ),
                )
              : const SizedBox.shrink();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
