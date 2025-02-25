import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void dispose() {
    _clientNameController.dispose();
    super.dispose();
  }

  void _addName() {
    if (_clientNameController.text.isNotEmpty) {
      context
          .read<ClientsBloc>()
          .add(AddNewClient(name: _clientNameController.text));
      _clientNameController.clear();
    }
  }

  void _deleteName(String name) {
    context.read<ClientsBloc>().add(DeleteClient(name: name));
  }

  void _updateClients() {
    try {
      context.read<ClientsBloc>().add(UpdateClients(
            folderId: widget.folderId,
          ));
      context.go('/home');
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
            onSubmit: _addName,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<ClientsBloc, ClientsState>(
              builder: (context, state) {
                if (state is ClientsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ClientsLoaded) {
                  return ListView.separated(
                    itemCount: state.namesList.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return SurnameListTile(
                        name: state.namesList[index],
                        onDelete: (context) {
                          _deleteName(state.namesList[index]);
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _updateClients,
              child: const Text('Сохранить изменения',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
