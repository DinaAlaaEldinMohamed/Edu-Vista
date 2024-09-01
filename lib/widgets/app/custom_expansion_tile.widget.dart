import 'package:edu_vista/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final IconData collapasedIcon;
  final IconData expandedIcon;

  const CustomExpansionTile({
    required this.title,
    required this.children,
    this.collapasedIcon = Icons.keyboard_double_arrow_right,
    this.expandedIcon = Icons.keyboard_double_arrow_down,
    super.key,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: _isExpanded ? Colors.white : ColorUtility.greyColor,
              border: Border.all(
                color: _isExpanded
                    ? ColorUtility.secondaryColor
                    : Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: _isExpanded
                        ? ColorUtility.secondaryColor
                        : ColorUtility.blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  _isExpanded ? widget.expandedIcon : widget.collapasedIcon,
                  color: _isExpanded
                      ? ColorUtility.secondaryColor
                      : ColorUtility.blackColor,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.children,
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        const SizedBox(height: 8.0), // Space between tile header and content
      ],
    );
  }
}
