import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/data/files/models/file.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_event.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_order_container.dart';

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
  late FocusNode _focusNode;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
    _focusNode = FocusNode();

    // Listen to page changes to update current index
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentIndex = _pageController.page!.round();
        });
      }
    });

    if (widget.clientId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<OrderBloc>().add(LoadOrder(
              folderId: widget.folderId.toString(),
              clientId: widget.clientId!,
            ));
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _goToPreviousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentIndex < widget.images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FolderSettingsBloc()
        ..add(LoadFolderSettings(folderId: widget.folderId.toString())),
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
        body: KeyboardListener(
          autofocus: true,
          focusNode: _focusNode,
          onKeyEvent: (event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                _goToPreviousPage();
              } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                _goToNextPage();
              }
            }
          },
          child: Stack(
            children: [
              PageView.builder(
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
                            widget.images[index].fullUrl,
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
                                          left: 16,
                                          right: 16,
                                          top: 0,
                                          bottom: 16),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                      ),
                                      width: 400,
                                      child: ImageOrderContainer(
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
              // Left arrow button
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    opacity: _currentIndex > 0 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: IgnorePointer(
                      ignoring: _currentIndex == 0,
                      child: InkWell(
                        onTap: _goToPreviousPage,
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Right arrow button
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    opacity:
                        _currentIndex < widget.images.length - 1 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: IgnorePointer(
                      ignoring: _currentIndex == widget.images.length - 1,
                      child: InkWell(
                        onTap: _goToNextPage,
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
