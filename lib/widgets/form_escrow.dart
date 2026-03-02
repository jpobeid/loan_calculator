import 'package:flutter/material.dart';
import 'package:loan_calculator/widgets/widgets.dart';

class FormEscrow extends StatefulWidget {
  final TextEditingController controllerTerm;
  final TextEditingController controllerRate;
  final TextEditingController controllerTax;
  final TextEditingController controllerInsurance;
  final TextEditingController controllerHoa;
  final TextEditingController controllerPmi;
  final int frequencyTax;
  final int frequencyInsurance;
  final int frequencyHoa;
  final void Function({
    required int frequencyTax,
    required int frequencyInsurance,
    required int frequencyHoa,
  }) onUpdateFrequencies;

  const FormEscrow({
    super.key,
    required this.controllerTerm,
    required this.controllerRate,
    required this.controllerTax,
    required this.controllerInsurance,
    required this.controllerHoa,
    required this.controllerPmi,
    required this.frequencyTax,
    required this.frequencyInsurance,
    required this.frequencyHoa,
    required this.onUpdateFrequencies,
  });

  @override
  State<FormEscrow> createState() => _FormEscrowState();
}

class _FormEscrowState extends State<FormEscrow> {
  //### Need to make a escrow from controllers and return this instead of separate frequencies...

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputRow(
          label: 'Loan term [months]',
          maxLength: 3,
          controller: widget.controllerTerm,
          formatToInt: true,
          selectableFrequency: false,
        ),
        InputRow(
          label: 'Interest rate [annual %]',
          maxLength: 6,
          controller: widget.controllerRate,
          formatToInt: false,
          selectableFrequency: false,
        ),
        InputRow(
          label: 'Property tax [\$]',
          maxLength: 7,
          controller: widget.controllerTax,
          formatToInt: true,
          selectableFrequency: true,
          dropdownValue: widget.frequencyTax,
          callback: (int value) {
            setState(() {
              widget.onUpdateFrequencies(
                frequencyTax: value,
                frequencyInsurance: widget.frequencyInsurance,
                frequencyHoa: widget.frequencyHoa,
              );
            });
          },
        ),
        InputRow(
          label: 'Insurance [\$]',
          maxLength: 7,
          controller: widget.controllerInsurance,
          formatToInt: true,
          selectableFrequency: true,
          dropdownValue: widget.frequencyInsurance,
          callback: (int value) {
            setState(() {
              widget.onUpdateFrequencies(
                frequencyTax: widget.frequencyTax,
                frequencyInsurance: value,
                frequencyHoa: widget.frequencyHoa,
              );
            });
          },
        ),
        InputRow(
          label: 'HOA [\$]',
          maxLength: 7,
          controller: widget.controllerHoa,
          formatToInt: true,
          selectableFrequency: true,
          hasQuarterly: true,
          dropdownValue: widget.frequencyHoa,
          callback: (int value) {
            setState(() {
              widget.onUpdateFrequencies(
                frequencyTax: widget.frequencyTax,
                frequencyInsurance: widget.frequencyInsurance,
                frequencyHoa: value,
              );
            });
          },
        ),
        InputRow(
          label: 'Monthly PMI [\$]',
          maxLength: 7,
          controller: widget.controllerPmi,
          formatToInt: true,
          selectableFrequency: false,
        ),
      ],
    );
  }
}
