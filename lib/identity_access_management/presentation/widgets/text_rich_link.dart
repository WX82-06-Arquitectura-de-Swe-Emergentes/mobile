import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextRichLink extends StatelessWidget {
  final String linkText;
  final String actionText;
  final String route;

  const TextRichLink(
      {Key? key,
      required this.linkText,
      required this.actionText,
      required this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: linkText,
        style: const TextStyle(color: Colors.white),
        children: <TextSpan>[
          TextSpan(
            text: actionText,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Navigator.of(context).pushNamed(route),
          ),
        ],
      ),
    );
  }
}
