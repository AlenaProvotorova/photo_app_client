import 'package:flutter/material.dart';
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
  final List<String> _namesList = [];

  @override
  void dispose() {
    _clientNameController.dispose();
    super.dispose();
  }

  void _addName() {
    if (_clientNameController.text.isNotEmpty) {
      setState(() {
        _namesList.add(_clientNameController.text);
        _clientNameController.clear();
      });
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
            child: ListView.builder(
              itemCount: _namesList.length,
              itemBuilder: (context, index) {
                return SurnameListTile(
                  name: _namesList[index],
                  onDelete: (context) {
                    setState(() {
                      _namesList.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement save changes logic
              },
              child: const Text('Сохранить изменения',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
