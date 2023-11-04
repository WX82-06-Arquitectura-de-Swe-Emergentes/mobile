import 'package:flutter/material.dart';
import 'package:frontend/common/utils/global_utils.dart';

class ResponsiveSpacer extends StatelessWidget {
  final double minHeight;
  final double maxHeight;
  final int width;

  const ResponsiveSpacer(
      {super.key,
      required this.minHeight,
      required this.maxHeight,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Utils.responsiveValue(context, minHeight, maxHeight, width));
  }
}
