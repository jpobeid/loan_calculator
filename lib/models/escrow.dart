import 'package:flutter/material.dart';
import 'package:loan_calculator/data/constants.dart';

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
}
