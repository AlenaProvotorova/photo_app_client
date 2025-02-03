import 'package:flutter/material.dart';
import 'package:photo_app/components/app_bar_custom.dart';
import 'package:photo_app/components/input_field.dart';
import 'package:photo_app/components/input_field_with_label.dart';
import 'package:photo_app/components/primary_button.dart';
import 'package:photo_app/repositories/user/user_repository.dart';
import 'package:photo_app/screens/login/view/login_screen.dart';
import 'package:photo_app/screens/sign_up/widgets/sign_up_title.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _errorMessage = '';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserRepository _userRepository = UserRepository();

  Future<void> _signUp(context) async {
    try {
      final response = await _userRepository.signUp(
        _usernameController.text,
        _userEmailController.text,
        _passwordController.text,
      );
      debugPrint(response.statusCode.toString() as String?);
      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        setState(() {
          _errorMessage = response.data['error'] ?? 'Unknown error';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
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
              const SignUpTitle(),
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
                        _signUp(context);
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
}
