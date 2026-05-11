import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_calculator/widgets/dialog_widgets.dart';

class OutputColumn extends StatelessWidget {
  final double roundedQ;
  final double monthlyPayment;
  final double totalInterest;
  final double totalPI;
  final List<double> sequenceDP;
  final List<double> sequenceDI;

  const OutputColumn({
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
    return Column(
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
        IconButton(
          icon: const Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.purple,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return InfoDialog(
                    roundedQ: roundedQ,
                    monthlyPayment: monthlyPayment,
                    totalInterest: totalInterest,
                    totalPI: totalPI,
                    sequenceDP: sequenceDP,
                    sequenceDI: sequenceDI,
                  );
                });
          },
        ),
      ],
    );
  }
}