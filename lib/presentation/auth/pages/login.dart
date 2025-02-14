import 'package:flutter/material.dart';
import 'package:photo_app/core/components/input_field.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/auth/models/signin_req_params.dart';
import 'package:photo_app/domain/auth/usecases/signin.dart';
import 'package:photo_app/service_locator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoginEnabled = false;
  bool isPasswordEnabled = false;

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

  bool get isLoginButtonEnabled => isLoginEnabled && isPasswordEnabled;
  Future<void> _login(context) async {
    final result = await sl<SignInUseCase>().call(
        params: SignInReqParams(
      email: _userEmailController.text,
      password: _passwordController.text,
    ));

    result.fold((e) {
      DisplayMessage.showMessage(context, e);
    }, (data) {
      Navigator.of(context).pushNamed('/home');
    });
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
    return Scaffold(
      body: Column(children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.blue[100],
          ),
        ),
        _loginForm(context),
      ]),
    );
  }

  Widget _loginForm(context) {
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
