import 'package:flutter/material.dart';

class ImagePrintSelector extends StatefulWidget {
  final String size;
  final int imageId;
  const ImagePrintSelector({
    super.key,
    required this.size,
    required this.imageId,
  });

  @override
  State<ImagePrintSelector> createState() => _ImagePrintSelectorState();
}

class _ImagePrintSelectorState extends State<ImagePrintSelector> {
  int selectedQuantity = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Заказать фото ${widget.size}',
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButton<int>(
            value: selectedQuantity,
            dropdownColor: Colors.black87,
            underline: const SizedBox(),
            style: const TextStyle(color: Colors.white),
            items: List.generate(
              10,
              (index) => DropdownMenuItem(
                value: index,
                child: Text('$index'),
              ),
            ),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedQuantity = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
