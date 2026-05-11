import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_calculator/data/constants.dart';
import 'package:loan_calculator/models/escrow.dart';
import 'package:loan_calculator/providers/escrow_provider.dart';
import 'package:loan_calculator/widgets/input_widgets.dart';

class FormEscrow extends ConsumerStatefulWidget {
  const FormEscrow({
    super.key,
  });

  @override
  ConsumerState<FormEscrow> createState() => _FormEscrowState();
}

class _FormEscrowState extends ConsumerState<FormEscrow> {
  final TextEditingController _controllerTax = TextEditingController();
  final TextEditingController _controllerInsurance = TextEditingController();
  final TextEditingController _controllerHoa = TextEditingController();
  final TextEditingController _controllerPmi = TextEditingController();
  late List<TextEditingController> _controllers;
  late Frequency _frequencyTax;
  late Frequency _frequencyInsurance;
  late Frequency _frequencyHoa;

  void _updateEscrowNotifier() {
    ref.read(escrowNotifierProvider.notifier).updateFromControllers(
          controllerTax: _controllerTax,
          controllerInsurance: _controllerInsurance,
          controllerHoa: _controllerHoa,
          controllerPmi: _controllerPmi,
          frequencyTax: _frequencyTax,
          frequencyInsurance: _frequencyInsurance,
          frequencyHoa: _frequencyHoa,
        );
  }

  @override
  void initState() {
    super.initState();
    Escrow escrow = ref.read(escrowNotifierProvider);
    _controllerTax.text = escrow.tax.toString();
    _controllerInsurance.text = escrow.insurance.toString();
    _controllerHoa.text = escrow.hoa.toString();
    _controllerPmi.text = escrow.pmi.toString();
    _frequencyTax = escrow.frequencyTax;
    _frequencyInsurance = escrow.frequencyInsurance;
    _frequencyHoa = escrow.frequencyHoa;

    _controllers = [
      _controllerTax,
      _controllerInsurance,
      _controllerHoa,
      _controllerPmi,
    ];
    for (TextEditingController e in _controllers) {
      e.addListener(() => setState(() {
            _updateEscrowNotifier();
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
          label: 'Property tax [\$]',
          maxLength: 7,
          controller: _controllerTax,
          formatToInt: true,
          selectableFrequency: true,
          dropdownValue: _frequencyTax,
          callback: (Frequency value) {
            setState(() {
              _frequencyTax = value;
              _updateEscrowNotifier();
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
              _updateEscrowNotifier();
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
              _updateEscrowNotifier();
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
