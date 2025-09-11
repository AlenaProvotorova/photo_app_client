import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/data/image_picker/repositories/desktop_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/mobile_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/web_image_picker.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';
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
    final selectedImages = await _imagePickerService.pickImages();
    if (selectedImages.isNotEmpty) {
      final bloc = context.read<WatermarkBloc>();

      bloc.add(UploadWatermark(
        userId: widget.userId,
        image: selectedImages.first,
        context: context,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<WatermarkBloc, WatermarkState>(
        builder: (context, state) {
      print('WatermarkState: $state'); // Отладочная информация
      print('State type: ${state.runtimeType}'); // Отладочная информация

      // Всегда отображаем блок, независимо от состояния
      final watermark = state is WatermarkLoaded ? state.watermark : null;
      print(
          'Watermark filename: ${watermark?.filename}'); // Отладочная информация
      print('Watermark is null: ${watermark == null}'); // Отладочная информация

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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state is WatermarkLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (watermark?.filename == null)
                      UploadWatermarkButton(
                        pickImages: (parentContext) async {
                          await _pickImages(parentContext);
                        },
                      )
                    else
                      Column(
                        children: [
                          WatermarkCard(url: watermark!.url),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _pickImages(context),
                                icon:
                                    const Icon(Icons.edit, color: Colors.black),
                                label: const Text('Изменить',
                                    style: TextStyle(color: Colors.black)),
                                style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.grey,
                                  ),
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
                                  side: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
