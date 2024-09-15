import 'package:edu_vista/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final IconData collapasedIcon;
  final IconData expandedIcon;
  final bool? isExpanded;
  final ValueChanged<bool>? onExpansionChanged;

  const CustomExpansionTile({
    required this.title,
    required this.children,
    this.collapasedIcon = Icons.keyboard_double_arrow_right,
    this.expandedIcon = Icons.keyboard_double_arrow_down,
    this.isExpanded,
    this.onExpansionChanged,
    super.key,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _internalIsExpanded = false;

  @override
  void initState() {
    super.initState();
    _internalIsExpanded = widget.isExpanded ?? false;
  }

  @override
  void didUpdateWidget(CustomExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != null &&
        widget.isExpanded != oldWidget.isExpanded) {
      _internalIsExpanded = widget.isExpanded!;
    }
  }

  void _toggleExpansion() {
    setState(() {
      _internalIsExpanded = !_internalIsExpanded;
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged!(_internalIsExpanded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = widget.isExpanded ?? _internalIsExpanded;

    return Column(
      children: [
        GestureDetector(
          onTap: _toggleExpansion,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: isExpanded ? Colors.white : ColorUtility.greyColor,
              border: Border.all(
                color: isExpanded
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
                    color: isExpanded
                        ? ColorUtility.secondaryColor
                        : ColorUtility.blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  isExpanded ? widget.expandedIcon : widget.collapasedIcon,
                  color: isExpanded
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
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
