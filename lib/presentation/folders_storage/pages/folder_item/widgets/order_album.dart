import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';

class OrderAlbum extends StatelessWidget {
  const OrderAlbum({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String getOrderAlbumText(bool orderAlbum) {
      if (orderAlbum) {
        return 'Альбом выбран';
      }
      return 'Альбом не выбран';
    }

    IconData getOrderAlbumIcon(bool orderAlbum) {
      if (orderAlbum) {
        return Icons.check_circle;
      }
      return Icons.circle_outlined;
    }

    return BlocBuilder<ClientsBloc, ClientsState>(
      builder: (context, state) {
        if (state is ClientsLoaded && state.selectedClient != null) {
          if (state.selectedClient!.orderAlbum == null) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Icon(
                          getOrderAlbumIcon(state.selectedClient!.orderAlbum!),
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          getOrderAlbumText(state.selectedClient!.orderAlbum!),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
