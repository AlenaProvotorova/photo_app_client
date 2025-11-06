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
import 'package:photo_app/presentation/settings/pages/widgets/watermark/watermark_card.dart';
import 'package:photo_app/core/components/file_drop_zone.dart';
import 'package:photo_app/data/image_picker/models/image_data.dart';

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
        _handleImageUpload(selectedImages.first);
      }
    } catch (e) {
      DisplayMessage.showMessage(context, 'Ошибка при выборе изображения: $e');
    }
  }

  void _handleImageUpload(ImageData image) {
    final bloc = context.read<WatermarkBloc>();

    bloc.add(UploadWatermark(
      userId: widget.userId,
      image: image,
      context: context,
    ));
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Водяной знак',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Будет добавляться при загрузке фотографий',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          if (state is WatermarkLoading)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color.fromARGB(95, 158, 158, 158), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(minWidth: 500, minHeight: 200),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            )
          else if (state is WatermarkLoaded) ...[
            Builder(
              builder: (context) {
                final hasWatermark =
                    state.watermark != null && state.watermark!.url.isNotEmpty;

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Builder(
                      builder: (context) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        final containerWidth = screenWidth;

                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: containerWidth,
                            minHeight: 200,
                          ),
                          child: hasWatermark
                              ? SizedBox(
                                  child:
                                      WatermarkCard(url: state.watermark!.url),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: Stack(
                                    children: [
                                      FileDropZone(
                                        visible: true,
                                        onFilesDropped: (images) {
                                          if (images.isNotEmpty) {
                                            _handleImageUpload(images.first);
                                          }
                                        },
                                        emptyMessage:
                                            'Перетащите изображение водяного знака сюда',
                                        dragMessage:
                                            'Отпустите изображение для загрузки',
                                        fullWidth: true,
                                        child: const SizedBox.expand(),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  _pickImages(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: const Size(
                                                      double.infinity, 48),
                                                ),
                                                child: const Text(
                                                    'Загрузить водяной знак',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Builder(
              builder: (context) {
                final hasWatermark =
                    state.watermark != null && state.watermark!.url.isNotEmpty;

                if (hasWatermark) {
                  return Column(
                    children: [
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
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ] else if (state is WatermarkError) ...[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color.fromARGB(95, 158, 158, 158), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(minWidth: 500, minHeight: 200),
                  child: Center(
                    child: Text(
                      'Ошибка: ${state.message}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    }));
  }
}
