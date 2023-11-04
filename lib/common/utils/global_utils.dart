import 'package:flutter/material.dart';

abstract class Utils {
  static String getFormattedDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static String formatPriceToPenTwoDecimals(double price) {
    if (price % 1 == 0) {
      return 'S/ ${price.toInt()}';
    } else {
      return 'S/ ${price.toStringAsFixed(2)}';
    }
  }

  static double responsiveValue(
      context, double min, double max, int defaultValue) {
    if (MediaQuery.of(context).size.width < defaultValue) {
      return min;
    } else {
      return max;
    }
  }
}
