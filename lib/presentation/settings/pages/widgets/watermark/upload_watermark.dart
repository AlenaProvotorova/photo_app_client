import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        : MobileImagePickerRepositoryImplementation();
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
    return BlocListener<UserBloc, UserState>(listener: (context, userState) {
      if (userState is UserLoaded) {
        context
            .read<WatermarkBloc>()
            .add(LoadWatermark(userId: userState.user.id.toString()));
      }
    }, child:
        BlocBuilder<WatermarkBloc, WatermarkState>(builder: (context, state) {
      if (state is WatermarkLoaded) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.watermark?.filename == null)
              UploadWatermarkButton(
                pickImages: (parentContext) async {
                  await _pickImages(parentContext);
                },
              )
            else
              Column(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: WatermarkCard(url: state.watermark!.url),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImages(context),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text('Изменить',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _removeWatermark,
                        icon: const Icon(Icons.delete),
                        label: const Text('Удалить'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    }));
  }
}
