import 'package:edu_vista/utils/images-utils.dart';
import 'package:edu_vista/widgets/onBoarding/onboarding-widget.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _activePage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _activePage = page;
    });
  }

  void _onNextPage() {
    if (_activePage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _onPreviousPage() {
    if (_activePage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSkip() {
    // Skip to the last page
    _pageController.jumpToPage(_pages.length - 1);
  }

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Certification and Badges',
      'image': ImagesUtils.getOnboardingImage(0),
      'description': 'Earn a certificate after completion of every course',
      'skip': true,
    },
    {
      'title': 'Progress Tracking',
      'image': ImagesUtils.getOnboardingImage(1),
      'description': 'Check your progress in every course',
      'skip': true,
    },
    {
      'title': 'Offline Access',
      'image': ImagesUtils.getOnboardingImage(2),
      'description': 'Make your course available offline',
      'skip': true,
    },
    {
      'title': 'Course Catalog',
      'image': ImagesUtils.getOnboardingImage(3),
      'description': 'View the courses you are enrolled',
      'skip': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: _pages.length,
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemBuilder: (BuildContext context, int index) {
          final page = _pages[index];
          return OnboardingWidget(
            title: page['title'],
            description: page['description'],
            image: page['image'],
            showSkipButton: page['skip'] && _activePage < _pages.length - 1,
            showGetStartedButton: _activePage == _pages.length - 1,
            onNextTap: _onNextPage,
            onPreviousTap: _onPreviousPage,
            onSkip: _onSkip,
            currentPageIndex: _activePage,
            totalPages: _pages.length,
          );
        },
      ),
    );
  }
}
