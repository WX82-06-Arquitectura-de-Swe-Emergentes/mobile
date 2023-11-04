import 'package:flutter/material.dart';
import 'package:frontend/common/utils/global_utils.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final Map<String, List<dynamic>> formErrors;

  const PasswordInput(
      {Key? key, required this.controller, required this.formErrors})
      : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: widget.controller,
          obscureText: obscurePassword,
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
            hintText: 'Password',
            contentPadding: EdgeInsets.symmetric(
              vertical: Utils.responsiveValue(context, 8, 12, 400),
              horizontal: Utils.responsiveValue(context, 8, 12, 400),
            ),
            hintStyle: TextStyle(
              fontSize: Utils.responsiveValue(context, 10, 12, 400),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                  size: Utils.responsiveValue(context, 16, 20, 400)),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
          ),
        ),
        SizedBox(height: Utils.responsiveValue(context, 1, 2, 400)),
        if (widget.formErrors.containsKey('password'))
          ...widget.formErrors['password']!
              .map((error) => Text(
                    error,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: Utils.responsiveValue(context, 10, 12, 400)),
                    textAlign: TextAlign.left,
                  ))
              .toList(),
      ],
    );
  }
}
