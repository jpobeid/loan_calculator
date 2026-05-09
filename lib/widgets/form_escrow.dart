import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_calculator/data/constants.dart';
import 'package:loan_calculator/providers/escrow_provider.dart';
import 'package:loan_calculator/widgets/widgets.dart';

class FormEscrow extends ConsumerStatefulWidget {
  const FormEscrow({
    super.key,
  });

  @override
  ConsumerState<FormEscrow> createState() => _FormEscrowState();
}

class _FormEscrowState extends ConsumerState<FormEscrow> {
  final TextEditingController _controllerTerm =
      TextEditingController(text: '360');
  final TextEditingController _controllerRate =
      TextEditingController(text: '0');
  final TextEditingController _controllerTax = TextEditingController(text: '0');
  final TextEditingController _controllerInsurance =
      TextEditingController(text: '0');
  final TextEditingController _controllerHoa = TextEditingController(text: '0');
  final TextEditingController _controllerPmi = TextEditingController(text: '0');
  late List<TextEditingController> _controllers;
  Frequency _frequencyTax = Frequency.monthly;
  Frequency _frequencyInsurance = Frequency.monthly;
  Frequency _frequencyHoa = Frequency.monthly;

  @override
  void initState() {
    super.initState();
    _controllers = [
      _controllerTerm,
      _controllerRate,
      _controllerTax,
      _controllerInsurance,
      _controllerHoa,
      _controllerPmi,
    ];
    for (TextEditingController e in _controllers) {
      e.addListener(() => setState(() {
            ref.read(escrowNotifierProvider.notifier).updateFromControllers(
                  controllerTax: _controllerTax,
                  controllerInsurance: _controllerInsurance,
                  controllerHoa: _controllerHoa,
                  controllerPmi: _controllerPmi,
                  frequencyTax: _frequencyTax,
                  frequencyInsurance: _frequencyInsurance,
                  frequencyHoa: _frequencyHoa,
                );
          }));
    }
  }

  @override
  void dispose() {
    for (TextEditingController e in _controllers) {
      e.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputRow(
          label: 'Loan term [months]',
          maxLength: 3,
          controller: _controllerTerm,
          formatToInt: true,
          selectableFrequency: false,
        ),
        InputRow(
          label: 'Interest rate [annual %]',
          maxLength: 6,
          controller: _controllerRate,
          formatToInt: false,
          selectableFrequency: false,
        ),
        InputRow(
          label: 'Property tax [\$]',
          maxLength: 7,
          controller: _controllerTax,
          formatToInt: true,
          selectableFrequency: true,
          dropdownValue: _frequencyTax,
          callback: (Frequency value) {
            setState(() {
              _frequencyTax = value;
            });
          },
        ),
        InputRow(
          label: 'Insurance [\$]',
          maxLength: 7,
          controller: _controllerInsurance,
          formatToInt: true,
          selectableFrequency: true,
          dropdownValue: _frequencyInsurance,
          callback: (Frequency value) {
            setState(() {
              _frequencyInsurance = value;
            });
          },
        ),
        InputRow(
          label: 'HOA [\$]',
          maxLength: 7,
          controller: _controllerHoa,
          formatToInt: true,
          selectableFrequency: true,
          hasQuarterly: true,
          dropdownValue: _frequencyHoa,
          callback: (Frequency value) {
            setState(() {
              _frequencyHoa = value;
            });
          },
        ),
        InputRow(
          label: 'Monthly PMI [\$]',
          maxLength: 7,
          controller: _controllerPmi,
          formatToInt: true,
          selectableFrequency: false,
        ),
      ],
    );
  }
}
