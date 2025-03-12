import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/data/clients/models/client.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';

class ClientSelector extends StatelessWidget {
  const ClientSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsBloc, ClientsState>(
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
                  decoration: const InputDecoration(
                    labelText: 'Выберите фамилию',
                    border: OutlineInputBorder(),
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
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      final selectedClient = state.namesList.firstWhere(
                        (client) => client.name == newValue,
                      );
                      context
                          .read<ClientsBloc>()
                          .add(SelectClient(client: selectedClient));
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
    );
  }
}
