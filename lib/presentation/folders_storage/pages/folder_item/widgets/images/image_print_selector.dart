import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';

class ImagePrintSelector extends StatefulWidget {
  final String size;
  final String formatName;
  final int imageId;
  final int folderId;
  final int defaultQuantity;
  const ImagePrintSelector({
    super.key,
    required this.size,
    required this.formatName,
    required this.imageId,
    required this.folderId,
    this.defaultQuantity = 0,
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
                onPressed: selectedQuantity > 0
                    ? () {
                        setState(() {
                          selectedQuantity--;
                        });
                        _updateOrder();
                      }
                    : null,
                icon: const Icon(Icons.remove),
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
                onPressed: selectedQuantity < 10
                    ? () {
                        setState(() {
                          selectedQuantity++;
                        });
                        _updateOrder();
                      }
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateOrder() {
    final clientState = context.read<ClientsBloc>().state;
    if (clientState is ClientsLoaded && clientState.selectedClient != null) {
      final orderBloc = context.read<OrderBloc>();

      final event = UpdateOrder(
        fileId: widget.imageId.toString(),
        clientId: clientState.selectedClient!.id.toString(),
        folderId: widget.folderId.toString(),
        formatName: widget.formatName,
        count: selectedQuantity.toString(),
      );

      orderBloc.add(event);
    }
  }
}
