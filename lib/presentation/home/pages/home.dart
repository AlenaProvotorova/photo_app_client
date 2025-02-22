import 'package:flutter/material.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/folders_storage.dart';
import 'package:photo_app/presentation/settings/pages/settings.dart';

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

  final List _pages = [
    const FoldersStorageScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: navigateBottomBar,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Файлы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}
