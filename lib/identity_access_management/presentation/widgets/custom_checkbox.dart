// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:frontend/common/utils/global_utils.dart';

class CustomCheckbox extends StatefulWidget {
  CustomCheckbox({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  String label;
  bool initialValue;
  ValueChanged<bool> onChanged;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.initialValue,
          onChanged: (value) {
            widget.onChanged(value!);
          },
          // onChanged: (value) {
          //   setState(() {
          //     widget.initialValue = value!;
          //   });
          //   widget.onChanged();
          // },
          visualDensity: VisualDensity.compact,
          fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
          checkColor: Colors.red,
        ),
        Text(
          widget.label,
          style: TextStyle(
            color: Colors.white,
            fontSize: Utils.responsiveValue(context, 8, 12, 400),
          ),
        ),
      ],
    );
  }
}
