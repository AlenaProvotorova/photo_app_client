import 'package:flutter/material.dart';
import 'package:photo_app/screens/login/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  content() {
    return [
      Expanded(
        flex: 1,
        child: Container(
          color: Colors.blue[100],
        ),
      ),
      const LoginForm(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: content()),
    );
  }
}
