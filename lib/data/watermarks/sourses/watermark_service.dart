import 'dart:typed_data';
import 'package:image/image.dart' as img;

class WatermarkService {
  static Future<Uint8List> applyWatermark({
    required Uint8List originalImage,
    required Uint8List watermarkImage,
  }) async {
    final original = img.decodeImage(originalImage);
    final watermark = img.decodeImage(watermarkImage);

    if (original == null || watermark == null) {
      throw Exception('Ошибка при обработке изображений');
    }

    final resizedWatermark = img.copyResize(
      watermark,
      width: original.width.round(),
      height: original.height.round(),
    );

    final x = original.width - resizedWatermark.width;
    final y = original.height - resizedWatermark.height;

    img.compositeImage(
      original,
      resizedWatermark,
      dstX: x,
      dstY: y,
      blend: img.BlendMode.alpha,
    );

    return Uint8List.fromList(img.encodeJpg(original));
  }
}
