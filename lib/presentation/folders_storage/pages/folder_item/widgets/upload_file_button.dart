import 'package:flutter/material.dart';
import 'package:photo_app/core/constants/for_test.dart';

class UploadFileButton extends StatelessWidget {
  final void Function(BuildContext context) pickImages;
  const UploadFileButton({super.key, required this.pickImages});

  @override
  Widget build(BuildContext context) {
    //TODO change check for admin
    return TEST_CONSTANTS.isAdmin
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  pickImages(context);
                },
                child: const Text('Загрузить фотографии',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
