import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/data/image/models/image.dart';

class FolderItemScreen extends StatefulWidget {
  final String folderId;
  const FolderItemScreen({super.key, required this.folderId});

  @override
  _FolderItemScreenState createState() => _FolderItemScreenState();
}

class _FolderItemScreenState extends State<FolderItemScreen> {
  List<ImageData> _images = [];

  Future<void> _pickImages() async {
    try {
      if (kIsWeb) {
        // Use file_picker for web
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.image,
        );
        if (result != null && result.files.isNotEmpty) {
          List<ImageData> selectedImages = result.files.map((file) {
            return ImageData(
              bytes: file.bytes, // Store bytes for Web
              path: null, // Path is null on Web
            );
          }).toList();

          setState(() {
            _images.addAll(selectedImages);
          });

          // Optional: Print image sizes
          print('Selected ${selectedImages.length} images');
          for (var image in selectedImages) {
            print('Image size: ${image.bytes?.length ?? 0} bytes');
          }
        }
      } else {
        // Use image_picker for mobile platforms
        final ImagePicker picker = ImagePicker();
        final List<XFile>? selectedFiles = await picker.pickMultiImage();
        if (selectedFiles != null && selectedFiles.isNotEmpty) {
          List<ImageData> selectedImages = [];
          for (var file in selectedFiles) {
            selectedImages.add(ImageData(
              path: file.path, // Store path for Mobile
              bytes: null, // Bytes are not needed for Mobile
            ));
          }

          setState(() {
            _images.addAll(selectedImages);
          });

          // Optional: Print image sizes
          print('Selected ${selectedImages.length} images');
          for (var image in selectedImages) {
            // Retrieve file size asynchronously
            if (image.path != null) {
              final file = File(image.path!);
              final size = await file.length();
              print('Image size: $size bytes');
            }
          }
        }
      }
    } catch (e) {
      print('Error picking images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking images: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: '',
        onPress: () {
          Navigator.pop(context);
        },
        showLeading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _images.isEmpty
                ? const Column(
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
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns
                      crossAxisSpacing: 10, // Horizontal spacing
                      mainAxisSpacing: 10, // Vertical spacing
                    ),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      final imageData = _images[index];
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
              width: double.infinity, // Button spans the full width
              child: ElevatedButton(
                onPressed: _pickImages,
                child: const Text('Загрузить фотографии'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
