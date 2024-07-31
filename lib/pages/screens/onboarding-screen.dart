import 'package:edu_vista/widgets/onboarding-widget.dart';
import 'package:flutter/material.dart';
import 'package:edu_vista/utils/app-utils.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _activePage = 0;
  void onNextPage() {
    if (_activePage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    }
  }

  final List<Map<String, dynamic>> _pages = [
    {
      'color': '#ffe24e',
      'title': 'Certification and Badges',
      'image': 'assets/images/certificate-and-badges.png',
      'description': "Earn a certificate after completion of every course",
      'skip': true
    },
    {
      'color': '#a3e4f1',
      'title': 'Progress Tracking',
      'image': 'assets/images/progress-tracking.png',
      'description': 'Check your Progress of every course',
      'skip': true
    },
    {
      'color': '#31b77a',
      'title': 'Offline Acces',
      'image': 'assets/images/offline-access.png',
      'description': 'Make your course available offline',
      'skip': true
    },
    {
      'color': '#31b77a',
      'title': 'Course Catalog',
      'image': 'assets/images/course-catalog.png',
      'description': 'View in which courses you are enrolled',
      'skip': false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: _pages.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: OnboardingWidget(
                    color: _pages[index]['color'],
                    title: _pages[index]['title'],
                    description: _pages[index]['description'],
                    skip: _pages[index]['skip'],
                    image: _pages[index]['image'],
                    onTap: onNextPage,
                    index: index),
              );
            },
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _activePage = page;
              });
            },
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 1.75,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildIndicator())
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildIndicator() {
    final indicators = <Widget>[];

    for (var i = 0; i < _pages.length; i++) {
      if (_activePage == i) {
        indicators.add(_indicatorsTrue());
      } else {
        indicators.add(_indicatorsFalse());
      }
    }
    return indicators;
  }

  Widget _indicatorsTrue() {
    final String color;
    if (_activePage == 0) {
      color = '#ffe24e';
    } else if (_activePage == 1) {
      color = '#a3e4f1';
    } else {
      color = '#31b77a';
    }

    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 6,
      width: 42,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: hexToColor(color),
      ),
    );
  }

  Widget _indicatorsFalse() {
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 8,
      width: 20,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade100,
      ),
    );
  }
}
