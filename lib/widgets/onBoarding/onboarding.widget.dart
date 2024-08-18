import 'package:edu_vista/screens/auth/login_screen.dart';
import 'package:edu_vista/services/pref.service.dart';
import 'package:edu_vista/utils/colors-utils.dart';
import 'package:edu_vista/widgets/onBoarding/nav_buttons.widget.dart';
import 'package:edu_vista/widgets/app/appButtons/app_elvated_btn.dart';
import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({
    required this.title,
    required this.description,
    required this.image,
    required this.showSkipButton,
    required this.showGetStartedButton,
    required this.onNextTap,
    required this.onPreviousTap,
    required this.onSkip,
    required this.currentPageIndex, // New property for indicator
    required this.totalPages, // New property for total pages
    super.key,
  });

  final String title;
  final String description;
  final String image;
  final bool showSkipButton;
  final bool showGetStartedButton;
  final VoidCallback onNextTap;
  final VoidCallback onPreviousTap;
  final VoidCallback onSkip;
  final int currentPageIndex; // Current page index for indicator
  final int totalPages; // Total number of pages for indicator

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    return ListView(
      children: [
        if (showSkipButton)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: onSkip,
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),

        //const Spacer(),
        // Title and description

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 60,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: screenHeight / 3,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(image, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 294,
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: ColorUtility.blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 60), // Space before indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildIndicators(),
              ),
            ],
          ),
        ),

        if (showGetStartedButton)
          Align(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 45),
                child: AppElvatedBtn(
                  title: "Login",
                  onPressed: () => onLogin(context),
                )),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 45),
            child:
                NavButtons(onNextTap: onNextTap, onPreviousTap: onPreviousTap),
          )
      ],
    );
  }

  void onLogin(BuildContext context) {
    PreferncesService.isOnboardingSeen = true;
    Navigator.pushReplacementNamed(context, LoginScreen.route);
  }

  List<Widget> _buildIndicators() {
    return List.generate(
      totalPages,
      (index) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 7,
        width: 42,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: currentPageIndex == index
              ? ColorUtility.secondaryColor
              : ColorUtility.darkGreyColor,
        ),
      ),
    );
  }
}
