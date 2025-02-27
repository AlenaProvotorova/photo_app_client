import 'package:flutter/material.dart';
import 'package:photo_app/data/files/models/file.dart';

class ImageCarousel extends StatefulWidget {
  final List<File> images;
  final Widget? child;
  final int initialIndex;

  const ImageCarousel({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.child,
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Expanded(
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Center(
                          child: Image.network(
                            widget.images[index].url,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    widget.child ??
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          color: Colors.black,
                          child: widget.child,
                        ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
