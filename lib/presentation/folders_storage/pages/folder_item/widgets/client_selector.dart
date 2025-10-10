import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/data/clients/models/client.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';

class ClientSelector extends StatefulWidget {
  final String folderId;
  const ClientSelector({
    super.key,
    required this.folderId,
  });

  @override
  State<ClientSelector> createState() => _ClientSelectorState();
}

class _ClientSelectorState extends State<ClientSelector> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<ClientsBloc, ClientsState>(
      listener: (context, state) {
        if (state is ClientsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: ${state.message}')),
          );
        }
      },
      child: BlocBuilder<ClientsBloc, ClientsState>(
        builder: (context, state) {
          if (state is ClientsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ClientsLoaded) {
            return Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      labelText: 'Выберите фамилию',
                      labelStyle: theme.textTheme.titleSmall,
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFFE4E4E4)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFFE4E4E4)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    dropdownColor: Colors.white,
                    menuMaxHeight: 300,
                    isDense: true,
                    isExpanded: true,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    items: state.namesList
                        .map<DropdownMenuItem<String>>((Client client) {
                      return DropdownMenuItem<String>(
                        value: client.name,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(client.name),
                        ),
                      );
                    }).toList(),
                    onTap: () {
                      if (state.selectedClient == null) {
                        context.read<ClientsBloc>().add(ResetSelectedClient());
                        _focusNode.unfocus();
                      }
                    },
                    onChanged: (String? newValue) async {
                      if (newValue != null) {
                        final selectedClient = state.namesList.firstWhere(
                          (client) => client.name == newValue,
                        );

                        // Сначала загружаем полную информацию о клиенте
                        context.read<ClientsBloc>().add(LoadClientById(
                            clientId: selectedClient.id.toString()));

                        context.read<OrderBloc>().add(
                              LoadOrder(
                                folderId: widget.folderId,
                                clientId: selectedClient.id,
                              ),
                            );

                        // Проверяем orderAlbum из исходного объекта клиента
                        if (selectedClient.orderAlbum == null) {
                          _showAlbumQuestionDialog(
                              context,
                              state,
                              widget.folderId,
                              context.read<ClientsBloc>(),
                              selectedClient);
                        }
                      }
                    },
                  ),
                ),
              ),
            );
          } else if (state is ClientsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

void _showAlbumQuestionDialog(BuildContext context, ClientsLoaded state,
    String folderId, ClientsBloc clientsBloc, Client client) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Вы планируете заказывать альбом?'),
      actions: [
        TextButton(
          onPressed: () {
            print('Нажата кнопка Да для клиента: ${client.id}');
            clientsBloc.add(UpdateOrderAlbum(
              clientId: client.id.toString(),
              orderAlbum: true,
            ));
            Navigator.pop(context);
          },
          child: const Text('Да'),
        ),
        TextButton(
          onPressed: () {
            print('Нажата кнопка Нет для клиента: ${client.id}');
            clientsBloc.add(UpdateOrderAlbum(
              clientId: client.id.toString(),
              orderAlbum: false,
            ));
            Navigator.pop(context);
          },
          child: const Text('Нет'),
        ),
      ],
    ),
  );
}
