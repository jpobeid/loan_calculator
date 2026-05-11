import 'package:flutter/material.dart';
import 'package:loan_calculator/data/constants.dart';
import 'package:loan_calculator/functions/validators.dart';

@immutable
class Escrow {
  final int tax;
  final int insurance;
  final int hoa;
  final int pmi;
  final Frequency frequencyTax;
  final Frequency frequencyInsurance;
  final Frequency frequencyHoa;

  const Escrow({
    required this.tax,
    required this.insurance,
    required this.hoa,
    required this.pmi,
    required this.frequencyTax,
    required this.frequencyInsurance,
    required this.frequencyHoa,
  });

  Escrow.initial()
      : tax = taxInitial,
        insurance = insuranceInitial,
        hoa = hoaInitial,
        pmi = pmiInitial,
        frequencyTax = frequencyTaxInitial,
        frequencyInsurance = frequencyInsuranceInitial,
        frequencyHoa = frequencyHoaInitial;

  factory Escrow.fromControllers({
    required TextEditingController controllerTax,
    required TextEditingController controllerInsurance,
    required TextEditingController controllerHoa,
    required TextEditingController controllerPmi,
    required Frequency frequencyTax,
    required Frequency frequencyInsurance,
    required Frequency frequencyHoa,
  }) {
    int? tax = validateInputInt(controllerTax.text);
    int? insurance = validateInputInt(controllerInsurance.text);
    int? hoa = validateInputInt(controllerHoa.text);
    int? pmi = validateInputInt(controllerPmi.text);
    if (tax != null && insurance != null && hoa != null && pmi != null) {
      return Escrow(
          tax: tax,
          insurance: insurance,
          hoa: hoa,
          pmi: pmi,
          frequencyTax: frequencyTax,
          frequencyInsurance: frequencyInsurance,
          frequencyHoa: frequencyHoa);
    } else {
      return Escrow.initial();
    }
  }
}
