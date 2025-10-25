import 'package:flutter/material.dart';

class ImagePrintSelector extends StatefulWidget {
  final String size;
  final String formatName;
  final int imageId;
  final int folderId;
  final int defaultQuantity;
  final Function(int) onQuantityChanged;
  final bool isConfirmed;
  final bool isBlocked;

  const ImagePrintSelector({
    super.key,
    required this.size,
    required this.formatName,
    required this.imageId,
    required this.folderId,
    this.defaultQuantity = 0,
    required this.onQuantityChanged,
    this.isConfirmed = false,
    this.isBlocked = false,
  });

  @override
  State<ImagePrintSelector> createState() => _ImagePrintSelectorState();
}

class _ImagePrintSelectorState extends State<ImagePrintSelector> {
  late int selectedQuantity;

  @override
  void initState() {
    super.initState();
    selectedQuantity = widget.defaultQuantity;
  }

  @override
  void didUpdateWidget(ImagePrintSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.defaultQuantity != widget.defaultQuantity) {
      selectedQuantity = widget.defaultQuantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            'Заказать фото ${widget.size}',
            style: theme.textTheme.titleMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: !widget.isBlocked && selectedQuantity > 0
                    ? () {
                        setState(() {
                          selectedQuantity--;
                        });
                        widget.onQuantityChanged(selectedQuantity);
                      }
                    : null,
                icon: Icon(
                  Icons.remove,
                  color: widget.isBlocked ? Colors.grey : null,
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  selectedQuantity.toString(),
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: !widget.isBlocked && selectedQuantity < 10
                    ? () {
                        setState(() {
                          selectedQuantity++;
                        });
                        widget.onQuantityChanged(selectedQuantity);
                      }
                    : null,
                icon: Icon(
                  Icons.add,
                  color: widget.isBlocked ? Colors.grey : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
