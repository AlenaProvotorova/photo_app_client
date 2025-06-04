import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';

class ShowSelectedButton extends StatelessWidget {
  final void Function() onPressed;
  final bool showSelected;
  const ShowSelectedButton({
    super.key,
    required this.onPressed,
    required this.showSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = showSelected
        ? ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            side: BorderSide(color: theme.colorScheme.primary),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 137, 186, 255),
            side: const BorderSide(color: Color.fromARGB(255, 137, 186, 255)),
          );
    return BlocBuilder<ClientsBloc, ClientsState>(
      builder: (context, state) {
        if (state is ClientsLoaded && state.selectedClient != null) {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  child: ElevatedButton(
                    style: buttonStyle,
                    onPressed: onPressed,
                    child: Text(
                      showSelected
                          ? 'Показать все фотографии'
                          : 'Показать только выбранные',
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
