import 'package:flutter/material.dart';
import 'package:loan_calculator/data/constants.dart';
import 'package:loan_calculator/functions/validators.dart';

class Terms {
  final int time;
  final double ratePercent;
  late double rate;

  Terms({
    required this.time,
    required this.ratePercent,
  }) {
    rate = ratePercent / 100;
  }

  Terms.initial()
      : time = timeInitial,
        ratePercent = ratePercentInitial,
        rate = ratePercentInitial / 100;

  factory Terms.fromControllers({
    required TextEditingController controllerTime,
    required TextEditingController controllerRatePercent,
  }) {
    int? time = validateInputInt(controllerTime.text);
    double? ratePercent = validateInputDouble(controllerRatePercent.text);

    if (time != null && ratePercent != null) {
      return Terms(
        time: time,
        ratePercent: ratePercent,
      );
    } else {
      return Terms.initial();
    }
  }

  bool isValid() {
    return (time > timeMin &&
        ratePercent > ratePercentMin &&
        ratePercent <= ratePercentMax);
  }
}
