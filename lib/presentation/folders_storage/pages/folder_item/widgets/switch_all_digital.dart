import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';

class SwitchAllDigital extends StatefulWidget {
  const SwitchAllDigital({
    super.key,
  });

  @override
  State<SwitchAllDigital> createState() => _SwitchAllDigitalState();
}

class _SwitchAllDigitalState extends State<SwitchAllDigital> {
  bool _printAll = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsBloc, ClientsState>(
      builder: (context, state) {
        if (state is ClientsLoaded && state.selectedClient != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Switch(
                  value: _printAll,
                  onChanged: (value) {
                    setState(() {
                      _printAll = value;
                    });
                  },
                ),
                const Text(
                  'ВСЕ ФОТО В ЦИФРОВОМ ВИДЕ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
