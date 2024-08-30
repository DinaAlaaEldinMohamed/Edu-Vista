import 'package:edu_vista/screens/auth/forgot_password_screen.dart';
import 'package:edu_vista/screens/auth/login_screen.dart';
import 'package:edu_vista/screens/auth/signup_screen.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/widgets/app/appButtons/app_elvated_btn.dart';
import 'package:edu_vista/widgets/app/appButtons/app_text_btn.dart';
import 'package:flutter/material.dart';

class AuthTemplateWidget extends StatefulWidget {
  final Future<void> Function()? onLogin;
  final Future<void> Function()? onSignUp;
  final Future<void> Function(String email)? onResetPassword;
  final Widget body;

  AuthTemplateWidget({
    this.onLogin,
    this.onSignUp,
    this.onResetPassword,
    required this.body,
    super.key,
  }) {
    assert(onLogin != null || onSignUp != null || onResetPassword != null,
        'onLogin, onSignUp, or onResetPassword should not be null');
  }

  @override
  State<AuthTemplateWidget> createState() => _AuthTemplateWidgetState();
}

class _AuthTemplateWidgetState extends State<AuthTemplateWidget> {
  EdgeInsetsGeometry get _padding =>
      const EdgeInsets.symmetric(vertical: 20, horizontal: 20);

  bool get isLogin => widget.onLogin != null;
  bool get isSignUp => widget.onSignUp != null;
  bool get isResetPassword => widget.onResetPassword != null;

  String get title {
    if (isLogin) return "Login";
    if (isSignUp) return "Sign Up";
    if (isResetPassword) return "Reset Password";
    return "Auth";
  }

  String get buttonText {
    if (isLogin) return "Login";
    if (isSignUp) return "Sign Up";
    if (isResetPassword) return "Submit";
    return "";
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: _padding
            .subtract(const EdgeInsets.symmetric(vertical: 10, horizontal: 0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 57,
                    child: AppElvatedBtn(
                      borderRadius: 15,
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        if (isLogin) {
                          await widget.onLogin?.call();
                        } else if (isSignUp) {
                          await widget.onSignUp?.call();
                        } else if (isResetPassword) {
                          // Call reset password method
                          final email = ''; // Add logic to get email input
                          await widget.onResetPassword?.call(email);
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              buttonText,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            if (isResetPassword)
              const SizedBox(
                height: 200,
              ),
            if (!isResetPassword) ...[
              const SizedBox(
                height: 40,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: ColorUtility.greyColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'Or sign with',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: ColorUtility.greyColor,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: AppElvatedBtn(
                            horizontal: 0,
                            backgroundColor: const Color(0xff1877f2),
                            textColor: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 35,
                                  height: 35,
                                  child: Image.asset(
                                    'assets/images/facebook.png',
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Sign In with Facebook',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {}),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      height: 46,
                      child: AppElvatedBtn(
                        backgroundColor: ColorUtility.pageBackgroundColor,
                        onPressed: () {},
                        child: Image.asset(
                          'assets/images/google.png',
                          width: 35,
                          height: 40,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin
                        ? 'Don\'t have an account?'
                        : 'Already have an account',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  AppTextBtn(
                    label: isLogin ? 'Sign Up' : 'Login',
                    onPressed: () {
                      Navigator.pushNamed(context,
                          isLogin ? SignUpScreen.route : LoginScreen.route);
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Text(
            title, // Page title
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
          ),
          Expanded(
            child: Padding(
              padding: _padding,
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isLogin)
                        const SizedBox(
                          height: 80,
                        ),
                      widget.body,
                      if (isLogin)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AppTextBtn(
                                label: 'Forgot Password ?',
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, ForgotPasswordScreen.route);
                                },
                              ),
                            ],
                          ),
                        ),
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
}
