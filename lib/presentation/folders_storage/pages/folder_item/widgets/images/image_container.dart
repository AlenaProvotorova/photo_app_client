import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/constants/for_test.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/files/models/remove_files_req_params.dart';
import 'package:photo_app/domain/files/usecases/remove_files.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_event.dart';
import 'package:photo_app/service_locator.dart';

class ImageContainer extends StatefulWidget {
  final int folderId;
  final String url;
  final int id;
  final String originalName;

  const ImageContainer({
    super.key,
    required this.folderId,
    required this.url,
    required this.id,
    required this.originalName,
  });

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  bool disabled = false;

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
      child: SizedBox(
        width: containerSize,
        height: containerSize,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ColorFiltered(
                      colorFilter: disabled
                          ? const ColorFilter.matrix([
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0.2126,
                              0.7152,
                              0.0722,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                            ])
                          : const ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.srcOver,
                            ),
                      child: Image.network(
                        widget.url,
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
                  ),
                ),
                TEST_CONSTANTS.isAdmin
                    ? Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _handleDeleteFile(context, widget.id),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 4), // Add spacing between image and filename
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
    );
  }

  Future<void> _handleDeleteFile(BuildContext context, int id) async {
    final result = await sl<RemoveFilesUseCase>().call(
      params: RemoveFilesReqParams(
        ids: [id],
        folderId: widget.folderId,
      ),
    );
    result.fold(
      (error) => DisplayMessage.showMessage(context, error.toString()),
      (success) {
        context
            .read<FilesBloc>()
            .add(LoadFiles(folderId: widget.folderId.toString()));
      },
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
