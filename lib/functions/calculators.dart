import 'package:loan_calculator/models/escrow.dart';
import 'package:loan_calculator/models/loan.dart';

double calculateMonthlyPayment(
  Loan loan,
  Escrow escrow,
) {
  double Q = loan.computeQ();
  double qTaxMonthly = escrow.tax / escrow.frequencyTax.divisorToMonthly;
  double qInsuranceMonthly =
      escrow.insurance / escrow.frequencyInsurance.divisorToMonthly;
  double qHoaMonthly = escrow.hoa / escrow.frequencyHoa.divisorToMonthly;

  double payment =
      Q + qTaxMonthly + qInsuranceMonthly + qHoaMonthly + escrow.pmi;
  return double.parse(payment.toStringAsFixed(2));
}
