import 'package:flutter/material.dart';
import 'package:photo_app/components/input_field.dart';
import 'package:photo_app/repositories/user/user_repository.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserRepository _userRepository = UserRepository();
  bool isLoginEnabled = false;
  bool isPasswordEnabled = false;

  bool get isLoginButtonEnabled => isLoginEnabled && isPasswordEnabled;

  @override
  void initState() {
    super.initState();

    _userEmailController.addListener(_updateLoginState);
    _passwordController.addListener(_updateLoginState);
  }

  @override
  void dispose() {
    _userEmailController.removeListener(_updateLoginState);
    _userEmailController.dispose();
    super.dispose();
  }

  Future<void> _login(context) async {
    try {
      await _userRepository.logIn(
          context, _userEmailController.text, _passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _updateLoginState() {
    setState(() {
      isLoginEnabled = _userEmailController.text.isNotEmpty &&
          _isValidEmail(_userEmailController.text);
      isPasswordEnabled = _passwordController.text.isNotEmpty;
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+.[^@]+').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final VoidCallback? onPressed = isLoginButtonEnabled
        ? () {
            _login(context);
          }
        : null;
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome!',
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  InputField(
                      child: TextFormField(
                    controller: _userEmailController,
                    decoration: const InputDecoration(
                        hintText: 'Email',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey)),
                  )),
                  const SizedBox(height: 20),
                  InputField(
                      child: TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey)),
                  )),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        color: isLoginButtonEnabled
                            ? theme.colorScheme.primary
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: TextButton(
                        onPressed: onPressed,
                        child: const Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not a member? ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        child: Text('Register now',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                            )),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/sign-up');
                        },
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
