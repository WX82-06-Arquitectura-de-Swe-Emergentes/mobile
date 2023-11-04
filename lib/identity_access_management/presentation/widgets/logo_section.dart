import 'package:flutter/material.dart';
import 'package:frontend/common/utils/global_utils.dart';

class LogoSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const LogoSection({Key? key, required this.title, required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: Utils.responsiveValue(context, 16.0, 32.0, 400)),
      child: Column(
        children: [
          SizedBox(
            height: Utils.responsiveValue(context, 64, 128, 400),
            width: Utils.responsiveValue(context, 64, 128, 400),
            child: const Image(image: AssetImage('images/logo.png')),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: Utils.responsiveValue(context, 24, 32, 400),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: Utils.responsiveValue(context, 8, 12, 400)),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: Utils.responsiveValue(context, 12, 16, 400),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
