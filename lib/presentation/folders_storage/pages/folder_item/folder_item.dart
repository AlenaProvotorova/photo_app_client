import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/data/image_picker/repositories/mobile_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/web_image_picker.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_bloc.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/client_selector.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/files_list.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/switch_all_digital.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/upload_file_button.dart';

class FolderItemScreen extends StatefulWidget {
  final String folderId;
  const FolderItemScreen({super.key, required this.folderId});

  @override
  FolderItemScreenState createState() => FolderItemScreenState();
}

class FolderItemScreenState extends State<FolderItemScreen> {
  late final ImagePickerRepository _imagePickerService;
  late final FilesBloc _filesBloc;
  late final ClientsBloc _clientsBloc;
  late final SizesBloc _sizesBloc;

  @override
  void initState() {
    super.initState();
    _imagePickerService = kIsWeb
        ? WebImagePickerRepositoryImplementation()
        : MobileImagePickerRepositoryImplementation();
    _filesBloc = FilesBloc()..add(LoadFiles(folderId: widget.folderId));
    _clientsBloc = ClientsBloc()..add(LoadClients(folderId: widget.folderId));
    _sizesBloc = SizesBloc()..add(LoadSizes());
  }

  Future<void> _pickImages(context) async {
    final selectedImages = await _imagePickerService.pickImages();
    if (selectedImages.isNotEmpty) {
      _filesBloc.add(UploadFiles(
        folderId: widget.folderId,
        images: selectedImages,
        context: context,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: '',
        onPress: () => context.go('/home'),
        showLeading: true,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => _filesBloc),
          BlocProvider(create: (context) => _clientsBloc),
          BlocProvider(create: (context) => _sizesBloc),
        ],
        child: Column(
          children: [
            const ClientSelector(),
            const SwitchAllDigital(),
            Expanded(
              child: FilesList(
                folderId: widget.folderId,
              ),
            ),
            UploadFileButton(
              pickImages: (context) async {
                await _pickImages(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
