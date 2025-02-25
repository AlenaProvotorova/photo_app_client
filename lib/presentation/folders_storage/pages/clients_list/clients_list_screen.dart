import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as router;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/presentation/folders_storage/pages/clients_list/bloc/clients_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/clients_list/bloc/clients_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/clients_list/widgets/clients_list.dart';

class ClientsListScreen extends StatelessWidget {
  final String folderId;
  const ClientsListScreen({super.key, required this.folderId});

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext ctx) {
    return BlocProvider(
      create: (context) => ClientsBloc()..add(LoadClients(folderId: folderId)),
      child: Scaffold(
        appBar: AppBarCustom(
          onPress: () {
            ctx.go('/home');
          },
          showLeading: true,
          title: 'Список фамилий',
        ),
        body: ClientsList(folderId: folderId),
      ),
    );
  }
}
