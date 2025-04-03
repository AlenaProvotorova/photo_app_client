import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';

class UploadFileButton extends StatelessWidget {
  final void Function(BuildContext context) pickImages;
  const UploadFileButton({super.key, required this.pickImages});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return state.user.isAdmin
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        pickImages(context);
                      },
                      child: const Text('Загрузить фотографии',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                )
              : const SizedBox.shrink();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
