import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/data/files/models/file.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_event.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_additional_photos_container.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_print_selector_container.dart';

class ImageCarousel extends StatefulWidget {
  final List<File> images;
  final int initialIndex;
  final int folderId;
  final int? clientId;

  const ImageCarousel({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.folderId,
    required this.clientId,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizesBloc = context.read<SizesBloc>();
    final clientsBloc = context.read<ClientsBloc>();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sizesBloc),
        BlocProvider.value(value: clientsBloc),
        BlocProvider(
          create: (context) => FolderSettingsBloc()
            ..add(LoadFolderSettings(folderId: widget.folderId.toString())),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => {
              Navigator.of(context).pop(),
              context.read<OrderBloc>().add(LoadOrder(
                    folderId: widget.folderId.toString(),
                    clientId: widget.clientId,
                  )),
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Center(
                          child: Image.network(
                            widget.images[index].url,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      BlocBuilder<ClientsBloc, ClientsState>(
                        builder: (context, clientsState) {
                          if (clientsState is ClientsLoaded &&
                              clientsState.selectedClient != null) {
                            return Positioned(
                              left: 0,
                              right: 8,
                              bottom: 8,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        top: 8,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                      ),
                                      width: 400,
                                      child: ImageAdditionalPhotosContainer(
                                        imageId: widget.images[index].id,
                                        folderId: widget.folderId,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      width: 400,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: ImagePrintSelectorContainer(
                                        imageId: widget.images[index].id,
                                        folderId: widget.folderId,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
