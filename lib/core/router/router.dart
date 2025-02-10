import 'package:photo_app/presentation/home_page/home_page.dart';
import 'package:photo_app/presentation/auth/pages/login.dart';
import 'package:photo_app/presentation/auth/pages/sign_up.dart';
import 'package:photo_app/core/utils/auth_guard.dart';

final routes = {
  '/': (context) => const AuthGuard(child: LoginPage()),
  '/home': (context) => const AuthGuard(child: HomePage()),
  '/sign-up': (context) => const AuthGuard(child: SignUpPage()),
};
