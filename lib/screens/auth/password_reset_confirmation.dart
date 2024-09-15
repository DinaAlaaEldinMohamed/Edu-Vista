import 'package:edu_vista/widgets/app/appButtons/app_elvated_btn.dart';
import 'package:edu_vista/widgets/app/app_text_form_field.widget.dart';
import 'package:flutter/material.dart';

class PasswordResetConfirmationScreen extends StatefulWidget {
  static const String route = '/confirm_reset_password';
  final String oobCode;

  const PasswordResetConfirmationScreen({super.key, required this.oobCode});

  @override
  State<PasswordResetConfirmationScreen> createState() =>
      _PasswordResetConfirmationScreenState();
}

class _PasswordResetConfirmationScreenState
    extends State<PasswordResetConfirmationScreen> {
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Future<void> _handleConfirmPassword() async {
  //   final newPassword = newPasswordController.text.trim();
  //   final confirmPassword = confirmPasswordController.text.trim();

  //   if (newPassword.isNotEmpty && newPassword == confirmPassword) {
  //     try {
  //       await context.read<AuthCubit>().resetPassword(
  //             context: context,
  //             oobCode: widget.oobCode,
  //             newPasswordController: newPasswordController,
  //           );
  //       Navigator.pushReplacementNamed(context, LoginScreen.route);
  //     } catch (e) {
  //       // Handle error state or show a message if needed
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Passwords do not match')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppTextFormField(
              controller: newPasswordController,
              hintText: 'New Password',
              labelText: 'New Password',
              obscureText: true,
            ),
            AppTextFormField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              labelText: 'Confirm Password',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : AppElvatedBtn(
                    onPressed: () {}, // _handleConfirmPassword,
                    child: const Text('Confirm Password'),
                  ),
          ],
        ),
      ),
    );
  }
}
