import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/widgets/app/app_text_form_field.widget.dart';
import 'package:edu_vista/widgets/auth/auth_template.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String route = '/forgot_password';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController emailController;
  bool _isLoading = false;

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplateWidget(
      onResetPassword: (email) async {
        setState(() {
          _isLoading = true;
        });
        try {
          await context.read<AuthCubit>().forgotPassword(
                context: context,
                emailController: emailController,
              );

          Navigator.pop(context);
        } catch (e) {
          print('error: $e');
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      },
      body: SafeArea(
        child: Column(
          children: [
            AppTextFormField(
              controller: emailController,
              hintText: 'demo@mail.com',
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
