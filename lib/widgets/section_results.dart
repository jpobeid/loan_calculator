import 'package:flutter/material.dart';
import 'package:loan_calculator/models/loan.dart';
import 'package:loan_calculator/widgets/output_widgets.dart';

class SectionResults extends StatelessWidget {
  final Loan loan;

  const SectionResults({
    super.key,
    required this.loan,
  });

  double _round(double x) {
    return double.parse(x.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return OutputColumn(
      roundedQ: _round(loan.computeQ()),
      monthlyPayment: _round(loan.getMonthlyPayment()),
      totalInterest: _round(loan.getTotalInterest()),
      totalPI: _round(loan.getTotalPI()),
      sequenceDP: loan.getSequenceDP(),
      sequenceDI: loan.getSequenceDI(),
    );
  }
}
