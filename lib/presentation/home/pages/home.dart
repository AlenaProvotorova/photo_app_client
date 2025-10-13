import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/folders_storage.dart';
import 'package:photo_app/presentation/settings/pages/settings.dart';
import 'package:photo_app/presentation/users/pages/users_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _resetNavigationIfNeeded(UserState state) {
    if (state is UserLoaded) {
      final isSuperUser = state.user.isSuperUser;
      final maxIndex = isSuperUser
          ? 2
          : 1; // 3 страницы для суперпользователя, 2 для обычного

      if (_selectedPageIndex > maxIndex) {
        setState(() {
          _selectedPageIndex = maxIndex;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        _resetNavigationIfNeeded(state);

        if (state is UserLoaded) {
          final isSuperUser = state.user.isSuperUser;

          final List<Widget> pages = [
            const FoldersStorageScreen(),
            if (isSuperUser) const UsersScreen(),
            const SettingsScreen(),
          ];

          final List<BottomNavigationBarItem> navItems = [
            const BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: 'Файлы',
            ),
            if (isSuperUser)
              const BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Пользователи',
              ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Настройки',
            ),
          ];

          return Scaffold(
            body: pages[_selectedPageIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedPageIndex,
              onTap: navigateBottomBar,
              items: navItems,
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
