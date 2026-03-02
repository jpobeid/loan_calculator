import 'dart:math' as maths;

import 'package:flutter/material.dart';
import 'package:loan_calculator/functions/validators.dart';

@immutable
class Loan {
  final int principal;
  final double rate;
  final int term;

  const Loan({
    required this.principal,
    required this.rate,
    required this.term,
  });

  factory Loan.fromControllers({
    required int principal,
    required TextEditingController controllerRate,
    required TextEditingController controllerTerm,
  }) {
    double? rate = validateInputDouble(controllerRate.text);
    int? term = validateInputInt(controllerTerm.text);
    if (rate != null && term != null) {
      return Loan(
        principal: principal,
        rate: rate,
        term: term,
      );
    } else {
      return Loan(
        principal: principal,
        rate: 0,
        term: 0,
      );
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
}
