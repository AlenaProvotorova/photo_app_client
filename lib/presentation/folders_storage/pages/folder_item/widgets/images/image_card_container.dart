import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';
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
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width * 0.28;
    final containerSize = imageSize * 1.15;
    final theme = Theme.of(context);
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
                  style: theme.textTheme.labelLarge,
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
    final userBloc = context.read<UserBloc>();
    final isAdmin = userBloc.state is UserLoaded
        ? (userBloc.state as UserLoaded).user.isAdmin
        : false;
    final shouldBeDisabled = !isAdmin &&
        clientsBloc.state is ClientsLoaded &&
        (clientsBloc.state as ClientsLoaded).selectedClient == null;
    if (disabled != shouldBeDisabled) {
      setState(() {
        disabled = shouldBeDisabled;
      });
    }
  }
}
