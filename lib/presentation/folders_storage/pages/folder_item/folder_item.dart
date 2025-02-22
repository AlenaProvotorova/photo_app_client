import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/core/components/image_container.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/files/models/upload_file_req_params.dart';
import 'package:photo_app/data/image_picker/repositories/mobile_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/web_image_picker%20copy.dart';
import 'package:photo_app/domain/files/usecases/upload_file.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/upload_file_button.dart';
import 'package:photo_app/service_locator.dart';

class FolderItemScreen extends StatefulWidget {
  final String folderId;
  const FolderItemScreen({super.key, required this.folderId});

  @override
  FolderItemScreenState createState() => FolderItemScreenState();
}

class FolderItemScreenState extends State<FolderItemScreen> {
  late final ImagePickerRepository _imagePickerService;
  late final FilesBloc _filesBloc;

  @override
  void initState() {
    super.initState();
    _imagePickerService = kIsWeb
        ? WebImagePickerRepositoryImplementation()
        : MobileImagePickerRepositoryImplementation();
    _filesBloc = FilesBloc()..add(LoadFiles(folderId: widget.folderId));
  }

  Future<void> _pickImages(context) async {
    final selectedImages = await _imagePickerService.pickImages();
    if (selectedImages.isNotEmpty) {
      for (var image in selectedImages) {
        final result = await sl<UploadFileUseCase>().call(
          params: UploadFileReqParams(
            folderId: int.parse(widget.folderId),
            formData: FormData.fromMap({
              'file': MultipartFile.fromBytes(
                image.bytes!,
                filename: image.path,
              ),
              // 'folderId': widget.folderId,
            }),
          ),
        );

        result.fold(
          (error) => DisplayMessage.showMessage(context, error),
          (success) {
            _filesBloc.add(LoadFiles(folderId: widget.folderId));
            DisplayMessage.showMessage(context, 'File loaded successfully');
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: '',
        onPress: () => Navigator.pop(context),
        showLeading: true,
      ),
      body: BlocProvider(
        create: (context) => _filesBloc,
        child: BlocBuilder<FilesBloc, FilesState>(
          builder: (context, state) {
            if (state is FilesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FilesLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: state.files.length,
                      itemBuilder: (context, index) {
                        final imageData = state.files[index];
                        print('imageData: $imageData');
                        // if (kIsWeb) {
                        //   return ImageContainer(url: imageData.url);
                        // } else {
                        //   return Text('image not kIsWeb');
                        // }
                        return ImageContainer(url: imageData.url);
                      },
                    ),
                  ),
                  UploadFileButton(pickImages: _pickImages),
                ],
              );
            } else if (state is FilesError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No files found'));
          },
        ),
      ),
    );
  }
}
