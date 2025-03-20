import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/data/sizes/models/size.dart';

class ImagePrintSelector extends StatefulWidget {
  final Size size;
  final int imageId;
  final int folderId;
  final int defaultQuantity;
  const ImagePrintSelector({
    super.key,
    required this.size,
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
    return Row(
      children: [
        Text(
          'Заказать фото ${widget.size.name}',
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
                final clientState = context.read<ClientsBloc>().state;
                if (clientState is ClientsLoaded &&
                    clientState.selectedClient != null) {
                  final orderBloc = context.read<OrderBloc>();

                  final event = UpdateOrder(
                    fileId: widget.imageId.toString(),
                    clientId: clientState.selectedClient!.id.toString(),
                    folderId: widget.folderId.toString(),
                    sizeId: widget.size.id,
                    count: selectedQuantity.toString(),
                  );

                  orderBloc.add(event);
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
