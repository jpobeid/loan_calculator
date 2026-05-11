import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_calculator/pages/amortization_page.dart';

class InfoDialog extends StatelessWidget {
  final double roundedQ;
  final double monthlyPayment;
  final double totalInterest;
  final double totalPI;
  final List<double> sequenceDP;
  final List<double> sequenceDI;

  const InfoDialog({
    super.key,
    required this.roundedQ,
    required this.monthlyPayment,
    required this.totalInterest,
    required this.totalPI,
    required this.sequenceDP,
    required this.sequenceDI,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Loan details'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Monthly payment [\$]: ${NumberFormat('#,###.##').format(monthlyPayment)}',
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
            Text(
              'Monthly P&I [\$]: ${NumberFormat('#,###.##').format(roundedQ)}',
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
            Text(
              'Total interest paid [\$]: ${NumberFormat('#,###.##').format(totalInterest)}',
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
            Text(
              'Total P&I paid [\$]: ${NumberFormat('#,###.##').format(totalPI)}',
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Amortization'),
          onPressed: () {
            if (roundedQ < 10) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payments too low (rounding errors)'),
                  duration: Duration(milliseconds: 500),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AmortizationPage(
                    sequenceDP: sequenceDP,
                    sequenceDI: sequenceDI,
                  ),
                ),
              );
            }
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
