import 'package:edu_vista/utils/app_enums.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class CourseChipsWidget extends StatefulWidget {
  final CourseOptions? selectedOption;
  final void Function(CourseOptions) onChanged;
  const CourseChipsWidget(
      {this.selectedOption, required this.onChanged, super.key});

  @override
  State<CourseChipsWidget> createState() => _CourseChipsWidgetState();
}

class _CourseChipsWidgetState extends State<CourseChipsWidget> {
  List<CourseOptions> chips = [
    CourseOptions.Lecture,
    CourseOptions.Download,
    CourseOptions.Certificate,
    CourseOptions.More
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        itemBuilder: (ctx, index) {
          return InkWell(
            onTap: () {
              widget.onChanged(chips[index]);
            },
            child: _ChipWidget(
              isSelected: chips[index] == widget.selectedOption,
              label: chips[index].name,
            ),
          );
        },
        separatorBuilder: (ctx, index) => const SizedBox(
          width: 10,
        ),
      ),
    );
  }
}

class _ChipWidget extends StatelessWidget {
  final bool isSelected;
  final String label;
  const _ChipWidget({required this.isSelected, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(8),
      side: BorderSide.none,
      shape: const StadiumBorder(),
      backgroundColor:
          isSelected ? ColorUtility.secondaryColor : ColorUtility.greyColor,
      label: Text(
        label,
        style: TextStyle(
            color: isSelected ? Colors.white : Colors.black, fontSize: 17),
      ),
      // color:
      //     MaterialStatePropertyAll(ColorUtility.deepYellow),
    );
  }
}
