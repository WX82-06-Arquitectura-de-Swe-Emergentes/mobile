import 'package:flutter/material.dart';

class SectionDisplayWidget extends StatelessWidget {
  const SectionDisplayWidget(
      {super.key, required this.title, required this.content, this.icon});

  final String title;
  final String content;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                color: Colors.white,
                size: 16.0,
              ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Text(
          content,
          style: const TextStyle(fontSize: 14.0,fontWeight: FontWeight.w300, color: Colors.white),
        ),
      ],
    );
  }
}
