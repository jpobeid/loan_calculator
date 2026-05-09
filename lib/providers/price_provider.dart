import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_calculator/models/price.dart';

class PriceNotifier extends Notifier<Price> {
  @override
  Price build() {
    return Price.zero();
  }

  void updateFromControllers({
    required TextEditingController controllerPrice,
    required TextEditingController controllerDown,
    required bool isDownPercentage,
  }) {
    state = Price.fromControllers(
      controllerPrice: controllerPrice,
      controllerDown: controllerDown,
      isDownPercentage: isDownPercentage,
    );
  }
}

final priceNotifierProvider =
    NotifierProvider<PriceNotifier, Price>(PriceNotifier.new);
