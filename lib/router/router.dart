import 'package:photo_app/screens/home_page/home_page.dart';
import 'package:photo_app/screens/login/view/login_screen.dart';
import 'package:photo_app/screens/sign_up/view/sign_up_screen.dart';
import 'package:photo_app/utils/auth_guard.dart';

final routes = {
  '/': (context) => const AuthGuard(child: LoginPage()),
  '/home': (context) => const AuthGuard(child: HomePage()),
  '/sign-up': (context) => const AuthGuard(child: SignUpPage()),
};
