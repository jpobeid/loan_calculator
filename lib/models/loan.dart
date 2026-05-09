import 'dart:math' as maths;

import 'package:flutter/material.dart';
import 'package:loan_calculator/models/escrow.dart';
import 'package:loan_calculator/models/terms.dart';

@immutable
class Loan {
  final int principal;
  final Terms terms;
  final Escrow escrow;

  const Loan({
    required this.principal,
    required this.terms,
    required this.escrow,
  });

  double computeQ() {
    int n = 12;
    num x = maths.pow((1 + terms.rate / n), -terms.time);
    return ((principal * terms.rate / n) / (1 - x));
  }

  double computeP(int nPaymentsMade) {
    int n = 12;
    double Q = computeQ();
    num x = maths.pow((1 + terms.rate / n), nPaymentsMade);
    double P = principal * x - Q * (n / terms.rate) * (x - 1);
    return P;
  }

  List<double> getSequenceP() {
    List<double> sequenceP = [];
    for (int iPayment = 0; iPayment <= terms.time; iPayment++) {
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
    return Q * terms.time;
  }

  double getTotalInterest() {
    double totalPI = getTotalPI();
    return totalPI - principal;
  }
}
