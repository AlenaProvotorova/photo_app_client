import 'package:flutter/material.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/presentation/folders_storage/pages/clients_list/widgets/clients_list.dart';

class ClientsListScreen extends StatelessWidget {
  final String folderId;
  const ClientsListScreen({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        title: 'Список фамилий',
      ),
      body: ClientsList(folderId: folderId),
    );
  }
}
