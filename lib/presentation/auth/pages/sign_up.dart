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

  Future<void> _singUp(appContext) async {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                                decoration: InputDecoration(
                                  hintText: 'Введите имя',
                                  border: InputBorder.none,
                                  hintStyle: theme.textTheme.titleSmall,
                                ),
                              )),
                          const SizedBox(height: 16),
                          InputFieldWithLabel(
                              label: 'Email',
                              child: TextFormField(
                                controller: _userEmailController,
                                decoration: InputDecoration(
                                  hintText: 'Введите email',
                                  border: InputBorder.none,
                                  hintStyle: theme.textTheme.titleSmall,
                                ),
                              )),
                          const SizedBox(height: 16),
                          InputFieldWithLabel(
                              label: 'Пароль',
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  hintText: 'Введите пароль',
                                  border: InputBorder.none,
                                  hintStyle: theme.textTheme.titleSmall,
                                ),
                              )),
                          const SizedBox(height: 16),
                          InputField(
                              child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Подтвердите пароль',
                              border: InputBorder.none,
                              hintStyle: theme.textTheme.titleSmall,
                            ),
                          )),
                          const SizedBox(height: 32),
                          PrimaryButton(
                              title: 'Зарегистрироваться',
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
