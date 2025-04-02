import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/data/image_picker/models/image_data.dart';
import 'package:photo_app/data/image_picker/repositories/mobile_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/web_image_picker.dart';
import 'package:photo_app/data/watermarks/sourses/watermark_service.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_event.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_bloc.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_event.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_event.dart';
import 'package:photo_app/entities/watermark/watermark_bloc.dart';
import 'package:photo_app/entities/watermark/watermark_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/client_selector.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/files/files_list.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/switch_all_digital.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/upload_file_button.dart';

class FolderItemScreen extends StatefulWidget {
  final String folderId;
  final String folderPath;
  const FolderItemScreen({
    super.key,
    required this.folderId,
    required this.folderPath,
  });

  @override
  FolderItemScreenState createState() => FolderItemScreenState();
}

class FolderItemScreenState extends State<FolderItemScreen> {
  late final ImagePickerRepository _imagePickerService;
  late final FilesBloc _filesBloc;
  late final UserBloc _userBloc;
  late final ClientsBloc _clientsBloc;
  late final SizesBloc _sizesBloc;
  late final OrderBloc _orderBloc;
  late final FolderSettingsBloc _folderSettingsBloc;
  late final WatermarkBloc _watermarkBloc;

  @override
  void initState() {
    super.initState();
    _imagePickerService = kIsWeb
        ? WebImagePickerRepositoryImplementation()
        : MobileImagePickerRepositoryImplementation();
    _userBloc = UserBloc()..add(LoadUser());
    _filesBloc = FilesBloc()..add(LoadFiles(folderId: widget.folderId));
    _clientsBloc = ClientsBloc()..add(LoadClients(folderId: widget.folderId));
    _folderSettingsBloc = FolderSettingsBloc()
      ..add(LoadFolderSettings(folderId: widget.folderId));
    _sizesBloc = SizesBloc()..add(LoadSizes());
    _orderBloc = OrderBloc();
    _watermarkBloc = WatermarkBloc()..add(LoadWatermark(userId: '1'));
  }

  Future<void> _pickImages(context, Uint8List watermarkBytes) async {
    final selectedImages = await _imagePickerService.pickImages();
    List<ImageData> formattedImages = [];
    if (selectedImages.isNotEmpty) {
      for (var file in selectedImages) {
        if (file.bytes != null) {
          final processedImage = ImageData(
            bytes: await WatermarkService.applyWatermark(
              originalImage: file.bytes!,
              watermarkImage: watermarkBytes,
            ),
            path: file.path,
          );
          formattedImages.add(processedImage);
        }
      }
    }

    if (formattedImages.isNotEmpty) {
      _filesBloc.add(UploadFiles(
        folderId: widget.folderId,
        images: formattedImages,
        context: context,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBarCustom(
        title: '',
        onPress: () => context.go('/home'),
        showLeading: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            height: 36, // Fixed height for the button
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                side: BorderSide(color: theme.colorScheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                context.go('/folder/${widget.folderPath}/full-order');
              },
              child: const Text('Весь заказ'),
            ),
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => _userBloc),
          BlocProvider(create: (context) => _filesBloc),
          BlocProvider(create: (context) => _clientsBloc),
          BlocProvider(create: (context) => _folderSettingsBloc),
          BlocProvider(create: (context) => _sizesBloc),
          BlocProvider(create: (context) => _orderBloc),
          BlocProvider(create: (context) => _watermarkBloc),
        ],
        child: Column(
          children: [
            ClientSelector(
              folderId: widget.folderId,
            ),
            const SwitchAllDigital(),
            Expanded(
              child: FilesList(
                folderId: widget.folderId,
                orderBloc: _orderBloc,
                clientsBloc: _clientsBloc,
              ),
            ),
            UploadFileButton(
              pickImages: (context, watermarkBytes) async {
                await _pickImages(context, watermarkBytes);
              },
            ),
          ],
        ),
      ),
    );
  }
}
