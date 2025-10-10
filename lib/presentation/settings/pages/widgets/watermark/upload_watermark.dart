import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/image_picker/repositories/desktop_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/mobile_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/web_image_picker.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';
import 'package:photo_app/entities/watermark/watermark_bloc.dart';
import 'package:photo_app/entities/watermark/watermark_event.dart';
import 'package:photo_app/entities/watermark/watermark_state.dart';
import 'package:photo_app/presentation/settings/pages/widgets/watermark/upload_watermark_button.dart';
import 'package:photo_app/presentation/settings/pages/widgets/watermark/watermark_card.dart';

class UploadWatermarkWidget extends StatefulWidget {
  final String userId;
  const UploadWatermarkWidget({super.key, required this.userId});

  @override
  State<UploadWatermarkWidget> createState() => _UploadWatermarkState();
}

class _UploadWatermarkState extends State<UploadWatermarkWidget> {
  late final ImagePickerRepository _imagePickerService;

  @override
  void initState() {
    super.initState();
    _imagePickerService = kIsWeb
        ? WebImagePickerRepositoryImplementation()
        : Platform.isAndroid || Platform.isIOS
            ? MobileImagePickerRepositoryImplementation()
            : DesktopImagePickerRepositoryImplementation();
  }

  void _removeWatermark() {
    final bloc = context.read<WatermarkBloc>();

    bloc.add(DeleteWatermark(
      userId: widget.userId,
      context: context,
    ));
  }

  Future<void> _pickImages(parentContext) async {
    try {
      final selectedImages = await _imagePickerService.pickImages();
      if (selectedImages.isNotEmpty) {
        final bloc = context.read<WatermarkBloc>();

        print('Загружаем водяной знак для пользователя: ${widget.userId}');
        print(
            'Размер изображения: ${selectedImages.first.bytes?.length ?? 'неизвестно'} байт');
        print('Путь к файлу: ${selectedImages.first.path}');

        bloc.add(UploadWatermark(
          userId: widget.userId,
          image: selectedImages.first,
          context: context,
        ));
      }
    } catch (e) {
      print('Ошибка при выборе изображения: $e');
      DisplayMessage.showMessage(context, 'Ошибка при выборе изображения: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<UserBloc, UserState>(listener: (context, userState) {
      if (userState is UserLoaded) {
        context
            .read<WatermarkBloc>()
            .add(LoadWatermark(userId: userState.user.id.toString()));
      }
    }, child:
        BlocBuilder<WatermarkBloc, WatermarkState>(builder: (context, state) {
      print('Состояние водяного знака: ${state.runtimeType}');
      if (state is WatermarkLoading) {
        print('Показываем индикатор загрузки');
        return const Center(child: CircularProgressIndicator());
      }
      if (state is WatermarkLoaded) {
        print('Состояние WatermarkLoaded, watermark: ${state.watermark}');
        if (state.watermark != null) {
          print('Водяной знак найден:');
          print('  - ID: ${state.watermark!.id}');
          print('  - Filename: ${state.watermark!.filename}');
          print('  - URL: ${state.watermark!.url}');
          print('  - URL пустой: ${state.watermark!.url.isEmpty}');
        } else {
          print('Водяной знак не найден (null)');
        }
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: const Color.fromARGB(95, 158, 158, 158), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 500),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Водяной знак',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Будет добавляться при загрузке фотографий',
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (state.watermark == null ||
                      state.watermark!.url.isEmpty) ...[
                    UploadWatermarkButton(
                      pickImages: (parentContext) async {
                        await _pickImages(parentContext);
                      },
                    ),
                  ] else ...[
                    WatermarkCard(url: state.watermark!.url),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickImages(context),
                          icon: const Icon(Icons.edit, color: Colors.black),
                          label: const Text('Изменить',
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _removeWatermark,
                          icon: const Icon(Icons.delete),
                          label: const Text('Удалить'),
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      } else if (state is WatermarkError) {
        print('Состояние WatermarkError: ${state.message}');
        return Center(
          child: Text(
            'Ошибка: ${state.message}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.red,
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    }));
  }
}
