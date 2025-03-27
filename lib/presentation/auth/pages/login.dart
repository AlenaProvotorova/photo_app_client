import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:photo_app/core/components/input_field.dart';
import 'package:photo_app/core/components/primary_button.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/core/theme/app_images.dart';
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
  Future<void> _login() async {
    final result = await sl<SignInUseCase>().call(
        params: SignInReqParams(
      email: _userEmailController.text,
      password: _passwordController.text,
    ));

    result.fold((e) {
      DisplayMessage.showMessage(context, e);
    }, (data) {
      context.go('/home');
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
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.splashBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        _loginForm(context),
      ]),
    );
  }

  Widget _loginForm(BuildContext appContext) {
    final theme = Theme.of(appContext);
    final VoidCallback? onPressed = isLoginButtonEnabled
        ? () {
            _login();
          }
        : null;
    return Expanded(
      flex: 1,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Добро пожаловать!',
                      style: theme.textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      InputField(
                          child: TextFormField(
                        controller: _userEmailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: InputBorder.none,
                          hintStyle: theme.textTheme.titleSmall,
                        ),
                      )),
                      const SizedBox(height: 20),
                      InputField(
                          child: TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Пароль',
                          border: InputBorder.none,
                          hintStyle: theme.textTheme.titleSmall,
                        ),
                      )),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        title: 'Войти',
                        onPress: onPressed,
                        disabled: !isLoginButtonEnabled,
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Еще не зарегистрированы? ',
                            style: theme.textTheme.titleSmall,
                          ),
                          TextButton(
                            child: Text('Зарегистрироваться',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: theme.colorScheme.primary,
                                )),
                            onPressed: () {
                              context.go('/sign-up');
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
        ),
      ),
    );
  }
}
