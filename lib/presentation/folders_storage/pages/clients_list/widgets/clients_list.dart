import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/clients_list/widgets/add_client_field.dart';
import 'package:photo_app/presentation/folders_storage/pages/clients_list/widgets/list_tile.dart';

class ClientsList extends StatefulWidget {
  final String folderId;
  const ClientsList({super.key, required this.folderId});

  @override
  ClientsListState createState() => ClientsListState();
}

class ClientsListState extends State<ClientsList> {
  final TextEditingController _clientNameController = TextEditingController();
  List<String> _namesList = [];

  @override
  void dispose() {
    _clientNameController.dispose();
    super.dispose();
  }

  void _updateClients() {
    try {
      context.read<ClientsBloc>().add(UpdateClients(
            folderId: widget.folderId,
            clients: _namesList,
          ));
      DisplayMessage.showMessage(context, 'Список клиентов успешно обновлен');
    } catch (e) {
      DisplayMessage.showMessage(
          context, 'Ошибка при сохранении списка клиентов');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AddClientField(
            controllerName: _clientNameController,
            onSubmit: () {
              final names = _clientNameController.text
                  .split(',')
                  .map((name) => name.trim())
                  .where((name) => name.isNotEmpty)
                  .toList();
              setState(() {
                _namesList.addAll(names);
              });
              _clientNameController.clear();
              _updateClients();
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<ClientsBloc, ClientsState>(
              builder: (context, state) {
                if (state is ClientsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ClientsLoaded) {
                  if (_namesList.isEmpty) {
                    _namesList =
                        state.namesList.map((client) => client.name).toList();
                  }
                  return ListView.separated(
                    itemCount: _namesList.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return SurnameListTile(
                        name: _namesList[index],
                        onDelete: (context) {
                          setState(() {
                            _namesList.removeAt(index);
                          });
                          _updateClients();
                        },
                      );
                    },
                  );
                } else if (state is ClientsError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
