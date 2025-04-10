import 'package:flutter/material.dart';

class WatermarkCard extends StatelessWidget {
  final String url;
  const WatermarkCard({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    const imageSize = 150.0;
    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
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
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
