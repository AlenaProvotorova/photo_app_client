import 'package:flutter/material.dart';

class UploadWatermarkButton extends StatelessWidget {
  final void Function(BuildContext context) pickImages;
  const UploadWatermarkButton({super.key, required this.pickImages});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            pickImages(context);
          },
          child: const Text('Загрузить водяной знак',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
