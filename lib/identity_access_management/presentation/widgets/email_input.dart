// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:frontend/common/utils/global_utils.dart';

class EmailInput extends StatelessWidget {
  final TextEditingController controller;
  final Map<String, List<dynamic>> formErrors;

  const EmailInput(
      {Key? key, required this.controller, required this.formErrors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(4),
            ),
            hintText: 'Email address',
            contentPadding: EdgeInsets.symmetric(
              vertical: Utils.responsiveValue(context, 8, 12, 400),
              horizontal: Utils.responsiveValue(context, 8, 12, 400),
            ),
            hintStyle: TextStyle(
              fontSize: Utils.responsiveValue(context, 10, 12, 400),
            ),
          ),
        ),
        SizedBox(height: Utils.responsiveValue(context, 1, 2, 400)),
        if (formErrors.containsKey('email'))
          ...formErrors['email']!
              .map((error) => Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: Utils.responsiveValue(context, 10, 12, 400),
                    ),
                    textAlign: TextAlign.left,
                  ))
              .toList(),
      ],
    );
  }
}
