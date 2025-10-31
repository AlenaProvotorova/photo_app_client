import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_app/core/theme/app_filters.dart';

class ImageCard extends StatelessWidget {
  final bool disabled;
  final String url;
  const ImageCard({
    super.key,
    required this.disabled,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width < 500
        ? MediaQuery.of(context).size.width * 0.4
        : MediaQuery.of(context).size.width * 0.265;
    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ColorFiltered(
          colorFilter: disabled ? AppFilters.gray : AppFilters.transparent,
          child: Image.network(
            url,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              if (kDebugMode) {
                print('Image load error for URL: $url');
                print('Error: $error');
                print('StackTrace: $stackTrace');
              }
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                      ),
                      if (kDebugMode)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Error loading image',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
