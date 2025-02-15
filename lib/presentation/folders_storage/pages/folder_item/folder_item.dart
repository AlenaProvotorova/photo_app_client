import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/image_picker/repositories/mobile_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/web_image_picker%20copy.dart';
import 'package:photo_app/domain/files/usecases/upload_file.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_state.dart';
import 'package:photo_app/service_locator.dart';

class FolderItemScreen extends StatefulWidget {
  final String folderId;
  const FolderItemScreen({super.key, required this.folderId});

  @override
  FolderItemScreenState createState() => FolderItemScreenState();
}

class FolderItemScreenState extends State<FolderItemScreen> {
  late final ImagePickerRepository _imagePickerService;

  @override
  void initState() {
    super.initState();
    _imagePickerService = kIsWeb
        ? WebImagePickerRepositoryImplementation()
        : MobileImagePickerRepositoryImplementation();
  }

  Future<void> _pickImages() async {
    try {
      final selectedImages = await _imagePickerService.pickImages();
      if (selectedImages.isNotEmpty) {
        context.read<FilesBloc>().add(AddImages(selectedImages, context));
      }
    } catch (e) {
      DisplayMessage.showMessage(context, 'Error picking images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilesBloc(
        imagePickerService: _imagePickerService,
        uploadFileUseCase: sl<UploadFileUseCase>(),
      )..add(LoadFiles()),
      child: Scaffold(
        appBar: AppBarCustom(
          title: '',
          onPress: () {
            Navigator.pop(context);
          },
          showLeading: true,
        ),
        body: BlocBuilder<FilesBloc, FilesState>(
          builder: (context, state) {
            if (state is FilesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FilesLoaded) {
              print('state.files1: ${state.files}');
              print('state.images1: ${state.images}');
              final List<dynamic> combined = [];

              combined.addAll(state.images);
              combined.addAll(state.files);
              print('state.combined: $combined');
              if (combined.isEmpty) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Папка пуста',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              }
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
                      itemCount: combined.length,
                      itemBuilder: (context, index) {
                        final imageData = combined[index];
                        if (kIsWeb) {
                          if (imageData.bytes != null) {
                            return Image.memory(
                              imageData.bytes!,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.red,
                              ),
                            );
                          }
                        } else {
                          if (imageData.path != null) {
                            return Image.file(
                              File(imageData.path!),
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _pickImages,
                        child: const Text('Загрузить фотографии'),
                      ),
                    ),
                  ),
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
