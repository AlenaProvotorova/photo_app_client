import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/core/components/input_field.dart';
import 'package:photo_app/core/components/input_field_with_label.dart';
import 'package:photo_app/core/components/primary_button.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/auth/models/signup_req_params.dart';
import 'package:photo_app/domain/auth/usecases/signup.dart';
import 'package:photo_app/service_locator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _errorMessage = '';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _passwordMismatchError;
  String? _nameError;
  String? _emailError;

  bool _isValidEmail(String email) {
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailPattern.hasMatch(email);
  }

  Future<void> _singUp(appContext) async {
    final isNameEmpty = _usernameController.text.trim().isEmpty;
    final emailValue = _userEmailController.text.trim();
    final isEmailEmpty = emailValue.isEmpty;
    final isEmailInvalid = !isEmailEmpty && !_isValidEmail(emailValue);
    if (isNameEmpty || isEmailEmpty || isEmailInvalid) {
      setState(() {
        _nameError = isNameEmpty ? 'Имя обязательно' : null;
        _emailError = isEmailEmpty
            ? 'Email обязателен'
            : (isEmailInvalid ? 'Некорректный email' : null);
      });
      return;
    }
    final passwordsMatch =
        _passwordController.text == _confirmPasswordController.text;
    if (!passwordsMatch) {
      setState(() {
        _passwordMismatchError = 'Пароли не совпадают';
      });
      return;
    }

    final result = await sl<SignUpUseCase>().call(
        params: SignUpReqParams(
      email: _userEmailController.text,
      password: _passwordController.text,
      name: _usernameController.text,
    ));

    result.fold((e) {
      DisplayMessage.showMessage(appContext, e);
    }, (data) {
      DisplayMessage.showMessage(appContext, 'Sign up successful');
      context.go('/');
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _userEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final passwordsFilled = _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
    final passwordsMatch = passwordsFilled &&
        _passwordController.text == _confirmPasswordController.text;
    final emailValue = _userEmailController.text.trim();
    final canSubmit = _usernameController.text.trim().isNotEmpty &&
        emailValue.isNotEmpty &&
        _isValidEmail(emailValue) &&
        passwordsMatch;
    return Scaffold(
      appBar: AppBarCustom(
        title: '',
        onPress: () {
          context.go('/');
        },
        showLeading: true,
      ),
      body: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _signUpTitle(),
                      const SizedBox(height: 24),
                      Column(
                        children: [
                          InputFieldWithLabel(
                              label: 'Имя',
                              child: TextFormField(
                                controller: _usernameController,
                                onChanged: (v) {
                                  setState(() {
                                    _nameError = v.trim().isEmpty
                                        ? 'Имя обязательно'
                                        : null;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Введите имя',
                                  border: InputBorder.none,
                                  hintStyle: theme.textTheme.titleSmall,
                                ),
                              )),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 18,
                            child: _nameError != null
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _nameError!,
                                      style: TextStyle(
                                        color: theme.colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 16),
                          InputFieldWithLabel(
                              label: 'Email',
                              child: TextFormField(
                                controller: _userEmailController,
                                onChanged: (v) {
                                  setState(() {
                                    final trimmed = v.trim();
                                    if (trimmed.isEmpty) {
                                      _emailError = 'Email обязателен';
                                    } else if (!_isValidEmail(trimmed)) {
                                      _emailError = 'Некорректный email';
                                    } else {
                                      _emailError = null;
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Введите email',
                                  border: InputBorder.none,
                                  hintStyle: theme.textTheme.titleSmall,
                                ),
                              )),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 18,
                            child: _emailError != null
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _emailError!,
                                      style: TextStyle(
                                        color: theme.colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 16),
                          InputFieldWithLabel(
                              label: 'Пароль',
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                onChanged: (value) {
                                  setState(() {
                                    _passwordMismatchError =
                                        (_confirmPasswordController
                                                    .text.isEmpty ||
                                                _confirmPasswordController
                                                        .text ==
                                                    value)
                                            ? null
                                            : 'Пароли не совпадают';
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Введите пароль',
                                  border: InputBorder.none,
                                  hintStyle: theme.textTheme.titleSmall,
                                ),
                              )),
                          const SizedBox(height: 16),
                          InputField(
                              child: TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                _passwordMismatchError = (value.isEmpty ||
                                        value == _passwordController.text)
                                    ? null
                                    : 'Пароли не совпадают';
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Подтвердите пароль',
                              border: InputBorder.none,
                              hintStyle: theme.textTheme.titleSmall,
                            ),
                          )),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 18,
                            child: _passwordMismatchError != null
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _passwordMismatchError!,
                                      style: TextStyle(
                                        color: theme.colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 32),
                          PrimaryButton(
                              title: 'Зарегистрироваться',
                              disabled: !canSubmit,
                              onPress: () {
                                _singUp(context);
                              }),
                          Text(_errorMessage)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signUpTitle() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Создайте аккаунт, чтобы начать',
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
