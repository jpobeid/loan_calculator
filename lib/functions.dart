import 'package:intl/intl.dart';
import 'dart:math' as maths;

int? validateInputInt(String textNumber) {
  try {
    int number = int.parse(textNumber.replaceAll(',', ''));
    return number;
  } catch (e) {
    return null;
  }
}

double? validateInputDouble(String textNumber) {
  try {
    double number = double.parse(textNumber.replaceAll(',', ''));
    return number;
  } catch (e) {
    return null;
  }
}

List<int> getDownAmounts(int price, int down, int downType) {
  late int downAmountPercent;
  late int downAmountDollar;
  if (downType == 0) {
    downAmountPercent = down;
    downAmountDollar = (price * down / 100).round();
  } else {
    // Already checked price > 0
    downAmountDollar = down;
    downAmountPercent = (down * 100 / price).round();
  }
  return [downAmountPercent, downAmountDollar];
}

String getLabelDownAmount(List<int> downAmounts, int downType) {
  int downAmountPercent = downAmounts[0];
  int downAmountDollar = downAmounts[1];
  String labelDownAmount =
      'Down amount ${downType == 0 ? '\$' : '%'}: ${downType == 0 ? NumberFormat('#,###').format(downAmountDollar) : downAmountPercent}';
  return labelDownAmount;
}

String getLabelLoanAmount(int loanAmount) {
  String labelLoanAmount =
      'Loan amount \$: ${NumberFormat('#,###').format(loanAmount)}';
  return labelLoanAmount;
}

double computeQ(int p0, double r, int N) {
  // Assuming monthly segmentation
  int n = 12;
  // N is the loan term
  num x = maths.pow((1 + r / n), -N);
  return ((p0 * r / n) / (1 - x));
}

double computeP(int p0, double r, double Q, int t) {
  // Assuming monthly segmentation
  int n = 12;
  // t is the number of payments made
  num x = maths.pow((1 + r / n), t);
  double P = p0 * x - Q * (n / r) * (x - 1);
  return P;
}

List<double> getSequenceP(int p0, double r, double Q, int N) {
  // Get the total principal balance over the loan
  List<double> output = [];
  for (int i = 0; i <= N; i++) {
    output.add(computeP(p0, r, Q, i));
  }
  return output;
}

List<double> getSequenceDP(List<double> sequenceP) {
  // Get the paid principal amounts over the loan
  List<double> output = [];
  for (int i = 1; i < sequenceP.length; i++) {
    output.add(sequenceP[i - 1] - sequenceP[i]);
  }
  return output;
}

double calculatePayment(
  double Q,
  int qTax,
  int qInsurance,
  int qHoa,
  int qPmi,
  int frequencyTax,
  int frequencyInsurance,
  int frequencyHoa,
) {
  // Correct for monthly payments by frequency
  double qTaxMonthly = frequencyTax == 0 ? qTax.toDouble() : qTax / 12;
  double qInsuranceMonthly =
      frequencyInsurance == 0 ? qInsurance.toDouble() : qInsurance / 12;
  double qHoaMonthly = qHoa.toDouble();
  if (frequencyHoa == 1) {
    qHoaMonthly = qHoa / 12;
  } else if (frequencyHoa == 2) {
    qHoaMonthly = qHoa / 3;
  }
  // Monthly P&I and then add other payments
  double payment = Q + qTaxMonthly + qInsuranceMonthly + qHoaMonthly + qPmi;
  return double.parse(payment.toStringAsFixed(2));
}
