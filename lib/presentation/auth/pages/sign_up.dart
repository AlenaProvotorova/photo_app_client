import 'package:flutter/material.dart';
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

  Future<void> _singUp(context) async {
    final result = await sl<SignUpUseCase>().call(
        params: SignUpReqParams(
      email: _userEmailController.text,
      password: _passwordController.text,
      name: _usernameController.text,
    ));

    result.fold((e) {
      DisplayMessage.showMessage(context, e);
    }, (data) {
      DisplayMessage.showMessage(context, 'Sign up successful');
      Navigator.of(context).pushNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: '',
        onPress: () {
          Navigator.pop(context);
        },
        showLeading: true,
      ),
      body: SingleChildScrollView(
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
                      label: 'Name',
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                            hintText: 'Name',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey)),
                      )),
                  const SizedBox(height: 16),
                  InputFieldWithLabel(
                      label: 'Email Address',
                      child: TextFormField(
                        controller: _userEmailController,
                        decoration: const InputDecoration(
                            hintText: 'Email Address',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey)),
                      )),
                  const SizedBox(height: 16),
                  InputFieldWithLabel(
                      label: 'Password',
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                            hintText: 'Create a password',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey)),
                      )),
                  const SizedBox(height: 16),
                  InputField(
                      child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Confirm a password',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey)),
                  )),
                  const SizedBox(height: 16),
                  PrimaryButton(
                      title: 'Sign up',
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
    );
  }

  Widget _signUpTitle() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Sign up',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Create an account to get started',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
