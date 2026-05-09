import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_calculator/data/constants.dart';
import 'package:loan_calculator/models/escrow.dart';

class EscrowNotifier extends Notifier<Escrow> {
  @override
  Escrow build() {
    return const Escrow.zero();
  }

  void updateFromControllers({
    required TextEditingController controllerTax,
    required TextEditingController controllerInsurance,
    required TextEditingController controllerHoa,
    required TextEditingController controllerPmi,
    required Frequency frequencyTax,
    required Frequency frequencyInsurance,
    required Frequency frequencyHoa,
  }) {
    state = Escrow.fromControllers(
      controllerTax: controllerTax,
      controllerInsurance: controllerInsurance,
      controllerHoa: controllerHoa,
      controllerPmi: controllerPmi,
      frequencyTax: frequencyTax,
      frequencyInsurance: frequencyInsurance,
      frequencyHoa: frequencyHoa,
    );
  }
}

final escrowNotifierProvider =
    NotifierProvider<EscrowNotifier, Escrow>(EscrowNotifier.new);
