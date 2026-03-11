import 'dart:math' as maths;

import 'package:flutter/material.dart';
import 'package:loan_calculator/functions/validators.dart';
import 'package:loan_calculator/models/escrow.dart';

@immutable
class Loan {
  final int principal;
  final double rate;
  final int term;
  final Escrow escrow;

  const Loan({
    required this.principal,
    required this.rate,
    required this.term,
    required this.escrow,
  });

  factory Loan.fromControllers({
    required int principal,
    required TextEditingController controllerRate,
    required TextEditingController controllerTerm,
    required Escrow escrow,
  }) {
    double? ratePercent = validateInputDouble(controllerRate.text);
    int? term = validateInputInt(controllerTerm.text);
    if (ratePercent != null && term != null) {
      return Loan(
        principal: principal,
        rate: ratePercent / 100,
        term: term,
        escrow: escrow,
      );
    } else {
      throw Error();
    }
  }

  double computeQ() {
    int n = 12;
    num x = maths.pow((1 + rate / n), -term);
    return ((principal * rate / n) / (1 - x));
  }

  double computeP(int nPaymentsMade) {
    int n = 12;
    double Q = computeQ();
    num x = maths.pow((1 + rate / n), nPaymentsMade);
    double P = principal * x - Q * (n / rate) * (x - 1);
    return P;
  }

  List<double> getSequenceP() {
    List<double> sequenceP = [];
    for (int iPayment = 0; iPayment <= term; iPayment++) {
      sequenceP.add(computeP(iPayment));
    }
    return sequenceP;
  }

  List<double> getSequenceDP() {
    List<double> sequenceP = getSequenceP();
    List<double> sequenceDP = [];
    for (int i = 1; i < sequenceP.length; i++) {
      sequenceDP.add(sequenceP[i - 1] - sequenceP[i]);
    }
    return sequenceDP;
  }

  List<double> getSequenceDI() {
    double Q = computeQ();
    List<double> sequenceDI = getSequenceDP().map((e) => Q - e).toList();
    return sequenceDI;
  }

  double getMonthlyPayment() {
    double Q = computeQ();
    double qTaxMonthly = escrow.tax / escrow.frequencyTax.divisorToMonthly;
    double qInsuranceMonthly =
        escrow.insurance / escrow.frequencyInsurance.divisorToMonthly;
    double qHoaMonthly = escrow.hoa / escrow.frequencyHoa.divisorToMonthly;

    double payment =
        Q + qTaxMonthly + qInsuranceMonthly + qHoaMonthly + escrow.pmi;
    return double.parse(payment.toStringAsFixed(2));
  }

  double getTotalPI() {
    double Q = computeQ();
    return Q * term;
  }

  double getTotalInterest() {
    double totalPI = getTotalPI();
    return totalPI - principal;
  }

  bool isValid() {
    return (rate > 0 && rate < 0.5 && term > 12);
  }
}
