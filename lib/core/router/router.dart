import 'package:go_router/go_router.dart';
import 'package:photo_app/core/utils/auth_guard.dart';
import 'package:photo_app/presentation/auth/pages/login.dart';
import 'package:photo_app/presentation/auth/pages/sign_up.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/folder_item.dart';
import 'package:photo_app/presentation/folders_storage/pages/clients_list/clients_list_screen.dart';
import 'package:photo_app/presentation/home/pages/home.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGuard(
        child: LoginPage(),
      ),
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
      path: '/folder/:folderId',
      builder: (context, state) {
        final folderId = state.pathParameters['folderId']!;
        return FolderItemScreen(folderId: folderId);
      },
    ),
    GoRoute(
      path: '/folder/:folderId/clients',
      builder: (context, state) {
        final folderId = state.pathParameters['folderId']!;
        return ClientsListScreen(folderId: folderId);
      },
    ),
  ],
  //TODO: Добавить экран для неправильных маршрутов
  // errorBuilder: (context, state) =>
  //     const NotFoundScreen(), // Экран для неправильных маршрутов
);
