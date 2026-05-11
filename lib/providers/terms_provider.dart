import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_calculator/models/terms.dart';

class TermsNotifier extends Notifier<Terms> {
  @override
  Terms build() {
    return Terms.initial();
  }

  void resetState() {
    state = Terms.initial();
  }

  void updateFromControllers({
    required TextEditingController controllerTime,
    required TextEditingController controllerRatePercent,
  }) {
    state = Terms.fromControllers(
      controllerTime: controllerTime,
      controllerRatePercent: controllerRatePercent,
    );
  }
}

final termsNotifierProvider =
    NotifierProvider<TermsNotifier, Terms>(TermsNotifier.new);
