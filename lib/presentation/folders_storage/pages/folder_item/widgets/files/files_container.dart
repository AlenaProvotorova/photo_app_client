import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/empty_container.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_carousel.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_container.dart';
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
                      final sizesBloc = context.read<SizesBloc>();
                      final clientsBloc = context.read<ClientsBloc>();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: sizesBloc),
                                BlocProvider.value(value: clientsBloc),
                              ],
                              child: ImageCarousel(
                                images: files,
                                initialIndex: index,
                              ),
                            );
                          },
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
