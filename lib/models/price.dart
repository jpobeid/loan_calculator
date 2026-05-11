import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_calculator/data/constants.dart';
import 'package:loan_calculator/functions/validators.dart';

class Price {
  final int price;
  final int downInputted;
  final bool isDownInputtedPercentage;
  int? downDollar;
  int? downPercent;
  int? cost;
  String labelDownAmount = 'Down amount: N/A';
  String labelCostAmount = 'Cost amount: N/A';

  Price({
    required this.price,
    required this.downInputted,
    required this.isDownInputtedPercentage,
  }) {
    if (isValid()) {
      if (isDownInputtedPercentage) {
        downPercent = downInputted;
        downDollar = (price * (downInputted / 100)).round();
      } else {
        downDollar = downInputted;
        downPercent = ((downInputted / price) * 100).round();
      }
      cost = price - downDollar!;
      labelDownAmount =
          'Down amount ${isDownInputtedPercentage ? '\$' : '%'}: ${isDownInputtedPercentage ? NumberFormat('#,###').format(downDollar) : downPercent}';
      labelCostAmount = 'Cost amount \$: ${NumberFormat('#,###').format(cost)}';
    }
  }

  Price.initial()
      : price = priceInitial,
        downInputted = downInputtedInitial,
        isDownInputtedPercentage = isDownInputtedPercentageInitial;

  factory Price.fromControllers({
    required TextEditingController controllerPrice,
    required TextEditingController controllerDown,
    required bool isDownPercentage,
  }) {
    int? price = validateInputInt(controllerPrice.text);
    int? down = validateInputInt(controllerDown.text);
    if (price != null && down != null) {
      return Price(
        price: price,
        downInputted: down,
        isDownInputtedPercentage: isDownPercentage,
      );
    } else {
      return Price.initial();
    }
  }

  bool isValid() {
    bool isPricePositive = price > 0;
    bool isCostPositive = true;
    if (!isDownInputtedPercentage) {
      isCostPositive = (price - downInputted) > 0;
    }
    return (isPricePositive && isCostPositive);
  }
}
