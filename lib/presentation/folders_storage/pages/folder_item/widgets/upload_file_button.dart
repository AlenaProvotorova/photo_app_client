import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';
import 'package:photo_app/entities/watermark/watermark_bloc.dart';
import 'package:photo_app/entities/watermark/watermark_state.dart';

class UploadFileButton extends StatelessWidget {
  final void Function(BuildContext context, Uint8List watermarkBytes)
      pickImages;
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
                      onPressed: () async {
                        final watermarkState =
                            context.read<WatermarkBloc>().state;
                        if (watermarkState is WatermarkLoaded &&
                            watermarkState.watermark != null) {
                          // Получаем водяной знак
                          final response = await Dio().get(
                            watermarkState.watermark!.url,
                            options: Options(responseType: ResponseType.bytes),
                          );
                          final watermarkBytes = response.data as Uint8List;
                          pickImages(context, watermarkBytes);
                        } else {
                          DisplayMessage.showMessage(
                              context, 'Водяной знак не найден');
                        }
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
