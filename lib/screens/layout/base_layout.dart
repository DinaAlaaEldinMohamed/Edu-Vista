import 'package:edu_vista/cubit/auth_cubit.dart';
//import 'package:edu_vista/screens/chat/chat_list_screen.dart';
import 'package:edu_vista/screens/courses/courses_list_screen.dart';

import 'package:edu_vista/screens/home/home_screen.dart';
import 'package:edu_vista/screens/search/search_screen.dart';
import 'package:edu_vista/screens/profile/profile_screen.dart';
import 'package:edu_vista/utils/colors_utils.dart';

import 'package:edu_vista/widgets/app/cart_icon_btn.widget.dart';
import 'package:edu_vista/widgets/app/custom_appbar.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edu_vista/widgets/app/custom_bottom_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseLayout extends StatefulWidget {
  final AppBar? customAppBar;
  final Widget body;
  final Widget? floatingActionButton;
  final bool changeAppbar;

  const BaseLayout({
    super.key,
    this.customAppBar,
    required this.body,
    this.floatingActionButton,
    this.changeAppbar = false,
  });

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  int _selectedIndex = 0;
  User? user = FirebaseAuth.instance.currentUser;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    BlocProvider.of<AuthCubit>(context).stream.listen((state) {
      if (state is ProfileImageUploaded) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
      }
    });
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const CoursesListScreen(),
    const SearchScreen(),
    //ChatListScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      appBar: widget.changeAppbar
          ? widget.customAppBar
          : _selectedIndex == 0
              ? AppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 80,
                  title: _buildWelcomeText(),
                  actions: const [
                    CartIconButton(),
                    SizedBox(width: 10),
                  ],
                )
              : _selectedIndex == 2
                  ? null
                  : CustomAppBar(
                      title: _selectedIndex == 1
                          ? 'Courses'
                          // : _selectedIndex == 3
                          // ? 'Chat'
                          : 'Profile',
                      actions: const [
                        CartIconButton(),
                        SizedBox(width: 10),
                      ],
                    ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: isLandscape
          ? null
          : CustomBottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              profileImageUrl: user?.photoURL,
            ),
    );
  }

  Widget _buildWelcomeText() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        children: [
          const TextSpan(
            text: 'Welcome ',
            style: TextStyle(color: ColorUtility.blackColor),
          ),
          TextSpan(
            text: user?.displayName ?? '',
            style: const TextStyle(color: ColorUtility.primaryColor),
          ),
        ],
      ),
    );
  }
}
