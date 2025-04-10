import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/empty_container.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_carousel.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_card_container.dart';
import 'package:photo_app/data/files/models/file.dart';

class FilesContainer extends StatelessWidget {
  final List<File> files;
  final String folderId;
  final OrderBloc orderBloc;
  final ClientsBloc clientsBloc;
  const FilesContainer(
      {super.key,
      required this.files,
      required this.folderId,
      required this.orderBloc,
      required this.clientsBloc});

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    final isAdmin = userBloc.state is UserLoaded
        ? (userBloc.state as UserLoaded).user.isAdmin
        : false;
    return files.isEmpty
        ? const Expanded(child: EmptyContainer(text: 'Папка пуста'))
        : Expanded(
            child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width < 500 ? 2 : 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final imageData = files[index];
                  final sizesBloc = context.read<SizesBloc>();
                  final clientsBloc = context.read<ClientsBloc>();
                  final orderBloc = context.read<OrderBloc>();
                  return GestureDetector(
                    onTap: () {
                      if (!isAdmin &&
                          clientsBloc.state is ClientsLoaded &&
                          (clientsBloc.state as ClientsLoaded).selectedClient ==
                              null) {
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: sizesBloc),
                                BlocProvider.value(value: clientsBloc),
                                BlocProvider.value(value: orderBloc),
                              ],
                              child: ImageCarousel(
                                images: files,
                                initialIndex: index,
                                folderId: int.parse(folderId),
                                clientId: clientsBloc.state is ClientsLoaded &&
                                        (clientsBloc.state as ClientsLoaded)
                                                .selectedClient !=
                                            null
                                    ? (clientsBloc.state as ClientsLoaded)
                                        .selectedClient!
                                        .id
                                    : null,
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: ImageCardContainer(
                      url: imageData.url,
                      id: imageData.id,
                      folderId: int.parse(folderId),
                      originalName: imageData.originalName,
                    ),
                  );
                }),
          );
  }
}
