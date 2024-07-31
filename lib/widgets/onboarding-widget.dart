import 'package:edu_vista/utils/app-utils.dart';
import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget(
      {required this.color,
      required this.title,
      required this.description,
      required this.skip,
      required this.image,
      required this.onTap,
      required this.index,
      super.key});
  final String color;
  final String title;
  final String description;
  final bool skip;
  final String image;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: hexToColor(color),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.86,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.fill)),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.16,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: index == 0
                        ? const Radius.circular(100)
                        : const Radius.circular(0),
                    topRight: index == 2
                        ? const Radius.circular(100)
                        : const Radius.circular(0),
                  )),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 62,
                    ),
                    Text(title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                          fontSize: 18, height: 1.5, color: Colors.grey),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: skip
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Skip Now',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          GestureDetector(
                            onTap: onTap,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: hexToColor(color),
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Icon(Icons.arrow_circle_right,
                                  color: Colors.white, size: 42),
                            ),
                          )
                        ],
                      )
                    : SizedBox(
                        height: 46,
                        child: MaterialButton(
                          color: hexToColor(color),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onPressed: () {},
                          child: const Text('Get Started',
                              style: TextStyle(color: Colors.white)),
                        ),
                      )),
          )
        ],
      ),
    );
  }
}
