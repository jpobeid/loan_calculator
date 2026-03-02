import 'package:flutter/material.dart';

class SectionResults extends StatelessWidget {
  const SectionResults({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [];
    if (loanAmount != null) {
      Row buttons = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
            child: Text(
              'Reset',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onPressed: () => resetStates(),
          ),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.green),
            child: Text(
              'Calculate',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onPressed: () => calculate(loanAmount),
          ),
        ],
      );
      columnChildren.add(buttons);
      if (_roundedQ != 0) {
        columnChildren.add(
          OutputColumn(
            roundedQ: _roundedQ,
            monthlyPayment: _monthlyPayment,
            totalInterest: _totalInterest,
            totalPI: _totalPI,
            sequenceDP: _sequenceDP,
            sequenceDI: _sequenceDI,
          ),
        );
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: columnChildren,
    );
  }
}
