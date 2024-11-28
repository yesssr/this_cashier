import 'package:flutter/material.dart';

import '../constant.dart';
import '../services/auth.dart';
import '../widget/button.dart';
import '../widget/form_input.dart';
import '../widget/form_pass.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    AuthService.loginUser(
      context: context,
      username: usernameController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "My Cashier",
                  style: bodyLargeBold.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Login",
                  style: bodyLargeBold,
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 312),
                  child: Text(
                    "Selamat datang kembali! Silahkan masukan username dan password untuk masuk!",
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: labelLargeMed,
                  ),
                ),
                const SizedBox(height: 16),
                FormInputWidget(
                  fieldController: usernameController,
                  nameField: "Username",
                  hint: "Isi dengan username anda",
                ),
                const SizedBox(height: 8),
                FormPasswordWidget(
                  passwordController: passwordController,
                  nameField: "Password",
                  hint: "Isi dengan password anda",
                ),
                const SizedBox(height: 16),
                fillBtn(
                  nameField: "Login",
                  context: context,
                  fixedMobileSize: true,
                  onPressed: () {
                    if (formKey.currentState!.validate()) login();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
