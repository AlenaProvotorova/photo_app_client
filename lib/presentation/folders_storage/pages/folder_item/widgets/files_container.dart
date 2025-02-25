import 'package:flutter/material.dart';
import 'package:photo_app/core/components/empty_container.dart';
import 'package:photo_app/core/components/image_carousel.dart';
import 'package:photo_app/core/components/image_container.dart';
import 'package:photo_app/data/files/models/file.dart';

class FilesContainer extends StatelessWidget {
  final List<File> files;
  final String folderId;
  const FilesContainer(
      {super.key, required this.files, required this.folderId});

  @override
  Widget build(BuildContext context) {
    return files.isEmpty
        ? const Expanded(child: EmptyContainer(text: 'Папка пуста'))
        : Expanded(
            child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final imageData = files[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ImageCarousel(
                            images: files,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: ImageContainer(
                      url: imageData.url,
                      id: imageData.id,
                      folderId: int.parse(folderId),
                    ),
                  );
                }),
          );
  }
}
