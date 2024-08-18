import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/widgets/app/app_text_form_field.widget.dart';
import 'package:edu_vista/widgets/auth/auth_template.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  static const String route = '/signup';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplateWidget(
      onSignUp: () async {
        await context.read<AuthCubit>().signUp(
            context: context,
            emailController: emailController,
            nameController: nameController,
            passwordController: passwordController);
      },
      body: Column(
        children: [
          AppTextFormField(
            controller: nameController,
            hintText: 'Dina Alaa ',
            labelText: 'Full Name',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 10,
          ),
          AppTextFormField(
            controller: emailController,
            hintText: 'Demo@gmail.com',
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 10,
          ),
          AppTextFormField(
            controller: passwordController,
            hintText: '***********',
            labelText: 'Password',
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 10,
          ),
          AppTextFormField(
            controller: confirmPasswordController,
            hintText: '***********',
            labelText: 'Confirm Password',
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
        ],
      ),
    );
  }
}
