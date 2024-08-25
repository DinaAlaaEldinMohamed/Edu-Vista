import 'package:edu_vista/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String? profileImageUrl;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.black,
      selectedItemColor: ColorUtility.secondaryColor,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      items: [
        _buildNavItem(Icons.home, 0),
        _buildNavItem(Icons.import_contacts, 1),
        _buildNavItem(Icons.search, 2),
        _buildNavItem(Icons.mode_comment_outlined, 3),
        _buildProfileItem(4), // Add profile item at the end
      ],
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          Icon(icon),
          if (currentIndex == index)
            Positioned(
              bottom: -8, // Position the underline below the icon
              left: 0,
              right: 0,
              child: Divider(
                thickness: 2,
                color: ColorUtility.secondaryColor, // Underline color
              ),
            ),
        ],
      ),
      label: '',
    );
  }

  BottomNavigationBarItem _buildProfileItem(int index) {
    return BottomNavigationBarItem(
      icon: profileImageUrl != null
          ? Stack(
              children: [
                CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15, // Adjust size as needed
                    backgroundImage: NetworkImage(profileImageUrl!)),
                if (currentIndex == index)
                  Positioned(
                    bottom: -8,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      color: ColorUtility.secondaryColor,
                    ),
                  ),
              ],
            )
          : const Icon(Icons.account_circle_outlined),
      label: '',
    );
  }
}