import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/constants/for_test.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_card.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_delete.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_order_info.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_select_text.dart';

class ImageCardContainer extends StatefulWidget {
  final int folderId;
  final String url;
  final int id;
  final String originalName;

  const ImageCardContainer({
    super.key,
    required this.folderId,
    required this.url,
    required this.id,
    required this.originalName,
  });

  @override
  State<ImageCardContainer> createState() => _ImageCardContainerState();
}

class _ImageCardContainerState extends State<ImageCardContainer> {
  bool disabled = false;
  bool isHovered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final clientsBloc = context.read<ClientsBloc>();
    final shouldBeDisabled = !TEST_CONSTANTS.isAdmin &&
        clientsBloc.state is ClientsLoaded &&
        (clientsBloc.state as ClientsLoaded).selectedClient == null;

    if (disabled != shouldBeDisabled) {
      setState(() {
        disabled = shouldBeDisabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width * 0.28;
    final containerSize = imageSize * 1.15;
    return BlocListener<ClientsBloc, ClientsState>(
      listener: (context, state) {
        _updateDisabledState();
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        cursor: disabled ? MouseCursor.defer : SystemMouseCursors.click,
        child: SizedBox(
          width: containerSize,
          height: containerSize,
          child: Column(
            children: [
              Stack(
                children: [
                  ImageCard(
                    disabled: disabled,
                    url: widget.url,
                  ),
                  if (isHovered && !disabled) const ImageSelectText(),
                  ImageDelete(
                    imageId: widget.id,
                    folderId: widget.folderId,
                  ),
                  ImageOrderInfo(
                    imageId: widget.id,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: imageSize,
                child: Text(
                  widget.originalName,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateDisabledState() {
    final clientsBloc = context.read<ClientsBloc>();
    final shouldBeDisabled = !TEST_CONSTANTS.isAdmin &&
        clientsBloc.state is ClientsLoaded &&
        (clientsBloc.state as ClientsLoaded).selectedClient == null;

    if (disabled != shouldBeDisabled) {
      setState(() {
        disabled = shouldBeDisabled;
      });
    }
  }
}
