import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/entities/users/bloc/users_bloc.dart';
import 'package:photo_app/entities/users/bloc/users_event.dart';
import 'package:photo_app/entities/users/bloc/users_state.dart';
import 'package:photo_app/service_locator.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UsersBloc>()..add(LoadUsers()),
      child: const _UsersScreenContent(),
    );
  }
}

class _UsersScreenContent extends StatelessWidget {
  const _UsersScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppBarCustom(
        title: 'Пользователи',
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is UsersError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка загрузки пользователей',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UsersBloc>().add(LoadUsers());
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is UsersLoaded) {
            if (state.users.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Пользователи не найдены',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 800),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE4E4E4),
                    ),
                  ),
                  child: DataTable(
                    columnSpacing: 20,
                    horizontalMargin: 16,
                    columns: [
                      DataColumn(
                        label: Text(
                          'Имя',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Email',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Администратор',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        numeric: false,
                      ),
                    ],
                    rows: state.users.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              user.name,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          DataCell(
                            Text(
                              user.email,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          DataCell(
                            Switch(
                              value: user.isAdmin,
                              onChanged: (value) {
                                context.read<UsersBloc>().add(
                                      UpdateUserIsAdmin(
                                          id: user.id, isAdmin: value),
                                    );
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          }

          return const Center(
            child: Text('Неизвестное состояние'),
          );
        },
      ),
    );
  }
}
