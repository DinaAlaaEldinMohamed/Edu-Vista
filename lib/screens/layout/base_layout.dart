import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/widgets/app/cart_icon_btn.widget.dart';
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
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  int _selectedIndex = 0;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    // Listen to changes in AuthCubit state
    BlocProvider.of<AuthCubit>(context).stream.listen((state) {
      if (state is ProfileImageUploaded) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, '/home');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/courses');
      } else if (index == 4) {
        Navigator.pushNamed(context, '/profile');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve screen size and orientation
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      appBar: widget.changeAppbar
          ? widget.customAppBar
          : AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 80,
              title: _buildWelcomeText(),
              actions: const [
                CartIconButton(),
                SizedBox(width: 10),
              ],
            ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                Expanded(
                  child: widget.body,
                ),
              ],
            );
          } else {
            return widget.body;
          }
        },
      ),
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: isLandscape
          ? null
          : CustomBottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              profileImageUrl: user?.photoURL),
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
