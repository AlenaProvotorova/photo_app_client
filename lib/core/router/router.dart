import 'package:go_router/go_router.dart';
import 'package:photo_app/core/utils/auth_guard.dart';
import 'package:photo_app/presentation/auth/pages/login.dart';
import 'package:photo_app/presentation/auth/pages/sign_up.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/folder_item.dart';
import 'package:photo_app/presentation/folders_storage/pages/clients_list/clients_list_screen.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_settings.dart/folder_settings_screen.dart';
import 'package:photo_app/presentation/folders_storage/pages/full_order.dart/full_order_screen.dart';
import 'package:photo_app/presentation/home/pages/home.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGuard(
        child: HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const AuthGuard(
        child: HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/folder/:folderPath',
      builder: (context, state) {
        final folderPath = state.pathParameters['folderPath']!;
        final folderId = folderPath.split('_').first;
        return FolderItemScreen(folderId: folderId, folderPath: folderPath);
      },
    ),
    GoRoute(
      path: '/folder/:folderPath/clients',
      builder: (context, state) {
        final folderPath = state.pathParameters['folderPath']!;
        final folderId = folderPath.split('_').first;
        return ClientsListScreen(folderId: folderId);
      },
    ),
    GoRoute(
      path: '/folder/:folderPath/settings',
      builder: (context, state) {
        final folderPath = state.pathParameters['folderPath']!;
        final folderId = folderPath.split('_').first;
        return FolderSettingsScreen(folderId: folderId, folderPath: folderPath);
      },
    ),
    GoRoute(
      path: '/folder/:folderPath/full-order',
      builder: (context, state) {
        final folderPath = state.pathParameters['folderPath']!;
        final folderId = folderPath.split('_').first;
        return FullOrderScreen(folderId: folderId, folderPath: folderPath);
      },
    ),
  ],
  //TODO: Добавить экран для неправильных маршрутов
  // errorBuilder: (context, state) =>
  //     const NotFoundScreen(), // Экран для неправильных маршрутов
);
