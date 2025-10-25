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
  String? _passwordStrengthError;
  String? _nameError;
  String? _emailError;
  bool _showPasswordHint = false;

  bool _isValidEmail(String email) {
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailPattern.hasMatch(email);
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return null;
    }

    if (password.length < 6) {
      return 'Пароль должен содержать минимум 6 символов';
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int complexityScore = 0;
    if (hasUppercase) complexityScore++;
    if (hasLowercase) complexityScore++;
    if (hasDigits) complexityScore++;
    if (hasSpecialChars) complexityScore++;
    if (password.length >= 8) complexityScore++;

    if (complexityScore < 3) {
      return 'Рекомендуется использовать заглавные и строчные буквы, цифры и специальные символы';
    }

    return null;
  }

  void _togglePasswordHint() {
    setState(() {
      _showPasswordHint = !_showPasswordHint;
    });
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
    final passwordStrengthError = _validatePassword(_passwordController.text);
    if (passwordStrengthError != null) {
      setState(() {
        _passwordStrengthError = passwordStrengthError;
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
    final passwordValid = _validatePassword(_passwordController.text) == null;
    final canSubmit = _usernameController.text.trim().isNotEmpty &&
        emailValue.isNotEmpty &&
        _isValidEmail(emailValue) &&
        passwordValid &&
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
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InputFieldWithLabel(
                                            label: 'Пароль',
                                            child: TextFormField(
                                              controller: _passwordController,
                                              obscureText: true,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              autofillHints: const [],
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              decoration: InputDecoration(
                                                hintText: 'Введите пароль',
                                                border: InputBorder.none,
                                                hintStyle:
                                                    theme.textTheme.titleSmall,
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  _passwordStrengthError =
                                                      _validatePassword(value);
                                                  _passwordMismatchError =
                                                      (_confirmPasswordController
                                                                  .text
                                                                  .isEmpty ||
                                                              _confirmPasswordController
                                                                      .text ==
                                                                  value)
                                                          ? null
                                                          : 'Пароли не совпадают';
                                                });
                                              },
                                            )),
                                        const SizedBox(height: 6),
                                        // Ошибка валидации пароля
                                        SizedBox(
                                          height: 18,
                                          child: _passwordStrengthError != null
                                              ? Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    _passwordStrengthError!,
                                                    style: TextStyle(
                                                      color: theme
                                                          .colorScheme.error,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Иконка подсказки
                                  GestureDetector(
                                    onTap: _togglePasswordHint,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        Icons.help_outline,
                                        size: 20,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Подсказка под полем пароля
                              if (_showPasswordHint)
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 22, 76, 254)
                                            .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 22, 76, 254)
                                              .withOpacity(0.2),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Требования к паролю:\n• Минимум 6 символов\n• Заглавные и строчные буквы\n• Цифры и символы (!@#\$%)',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 22, 76, 254),
                                      fontSize: 12,
                                      height: 1.3,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          InputField(
                              child: TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            autofillHints: const [],
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              hintText: 'Подтвердите пароль',
                              border: InputBorder.none,
                              hintStyle: theme.textTheme.titleSmall,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _passwordMismatchError = (value.isEmpty ||
                                        value == _passwordController.text)
                                    ? null
                                    : 'Пароли не совпадают';
                              });
                            },
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
