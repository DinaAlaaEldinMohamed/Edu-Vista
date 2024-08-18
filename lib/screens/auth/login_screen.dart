import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/widgets/app/app_text_form_field.widget.dart';
import 'package:edu_vista/widgets/auth/auth_template.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplateWidget(
      onLogin: () async {
        await context.read<AuthCubit>().login(
            context: context,
            emailController: emailController,
            passwordController: passwordController);
      },
      body: SafeArea(
        child: Column(
          children: [
            AppTextFormField(
              controller: emailController,
              hintText: 'Enter your email address',
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 20,
            ),
            AppTextFormField(
              controller: passwordController,
              hintText: 'Enter your password',
              labelText: 'Password',
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
          ],
        ),
      ),
    );
  }
}
