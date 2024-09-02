import 'package:edu_vista/utils/text_utility.dart';
import 'package:flutter/material.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/widgets/app/cart_icon_btn.widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final double height;

  const CustomAppBar({
    Key? key,
    this.title,
    this.actions,
    this.height = 80.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: height,
      title: title != null
          ? Center(
              child: Text(title!, style: TextUtils.headlineStyle),
            )
          : null,
      actions: actions ??
          const [
            CartIconButton(),
            SizedBox(width: 10),
          ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
