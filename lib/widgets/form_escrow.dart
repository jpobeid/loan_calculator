import 'package:flutter/material.dart';
import 'package:loan_calculator/data/constants.dart';
import 'package:loan_calculator/models/escrow.dart';
import 'package:loan_calculator/models/loan.dart';
import 'package:loan_calculator/models/price.dart';
import 'package:loan_calculator/widgets/widgets.dart';

class FormEscrow extends StatefulWidget {
  final Price price;

  const FormEscrow({
    super.key,
    required this.price,
  });

  @override
  State<FormEscrow> createState() => _FormEscrowState();
}

class _FormEscrowState extends State<FormEscrow> {
  final TextEditingController _controllerTerm =
      TextEditingController(text: '360');
  final TextEditingController _controllerRate =
      TextEditingController(text: '0');
  final TextEditingController _controllerTax = TextEditingController(text: '0');
  final TextEditingController _controllerInsurance =
      TextEditingController(text: '0');
  final TextEditingController _controllerHoa = TextEditingController(text: '0');
  final TextEditingController _controllerPmi = TextEditingController(text: '0');
  Frequency _frequencyTax = Frequency.monthly;
  Frequency _frequencyInsurance = Frequency.monthly;
  Frequency _frequencyHoa = Frequency.monthly;

  @override
  void dispose() {
    List<TextEditingController> controllers = [
      _controllerTerm,
      _controllerRate,
      _controllerTax,
      _controllerInsurance,
      _controllerHoa,
      _controllerPmi,
    ];
    for (TextEditingController e in controllers) {
      e.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Loan loan = Loan.fromControllers(
      principal: widget.price.cost!,
      controllerRate: _controllerRate,
      controllerTerm: _controllerTerm,
    );
    Escrow escrow = Escrow.fromControllers(
      controllerTax: _controllerTax,
      controllerInsurance: _controllerInsurance,
      controllerHoa: _controllerHoa,
      controllerPmi: _controllerPmi,
      frequencyTax: _frequencyTax,
      frequencyInsurance: _frequencyInsurance,
      frequencyHoa: _frequencyHoa,
    );
    print(loan.toString());
    print(escrow.toString());

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
