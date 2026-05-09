import 'package:flutter/material.dart';
import 'package:loan_calculator/functions/validators.dart';

@immutable
class Terms {
  final double rate;
  final int time;

  const Terms({
    required this.rate,
    required this.time,
  });

  const Terms.zero()
      : rate = 0,
        time = 0;

  factory Terms.fromControllers({
    required TextEditingController controllerRate,
    required TextEditingController controllerTime,
  }) {
    double? ratePercent = validateInputDouble(controllerRate.text);
    int? time = validateInputInt(controllerTime.text);
    if (ratePercent != null && time != null) {
      return Terms(
        rate: ratePercent / 100,
        time: time,
      );
    } else {
      return const Terms.zero();
    }
  }

  bool isValid() {
    return (rate > 0 && rate < 0.5 && time > 12);
  }
}
