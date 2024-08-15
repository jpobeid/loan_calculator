import 'package:flutter/material.dart';
import 'package:loan_calculator/functions.dart';
import 'package:loan_calculator/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Inputs
  final TextEditingController _price = TextEditingController(text: '0');
  final TextEditingController _down = TextEditingController(text: '0');
  int _downType = 0;
  final TextEditingController _term = TextEditingController(text: '360');
  final TextEditingController _rate = TextEditingController(text: '0');
  final TextEditingController _tax = TextEditingController(text: '0');
  final TextEditingController _insurance = TextEditingController(text: '0');
  final TextEditingController _hoa = TextEditingController(text: '0');
  final TextEditingController _pmi = TextEditingController(text: '0');
  int _frequencyTax = 0;
  int _frequencyInsurance = 0;
  int _frequencyHoa = 0;

  // Outputs
  double _roundedQ = 0;
  double _monthlyPayment = 0;
  double _totalInterest = 0;
  double _totalPI = 0;
  List<double> _sequenceDP = [];
  List<double> _sequenceDI = [];

  @override
  void initState() {
    super.initState();
    List<TextEditingController> controllers = [
      _price,
      _down,
      _term,
      _rate,
      _tax,
      _insurance,
      _hoa,
      _pmi,
    ];
    for (TextEditingController controller in controllers) {
      controller.addListener(() {
        setState(() {
          resetOutputs();
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    List<TextEditingController> controllers = [
      _price,
      _down,
      _term,
      _rate,
      _tax,
      _insurance,
      _hoa,
      _pmi,
    ];
    for (TextEditingController e in controllers) {
      e.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    String labelDownAmount = 'Down amount: N/A';
    String labelLoanAmount = 'Loan amount: N/A';
    int? price = validateInputInt(_price.text);
    int? down = validateInputInt(_down.text);
    int? loanAmount;
    if (price != null && price > 0 && down != null) {
      List<int> downAmounts = getDownAmounts(price, down, _downType);
      int downAmountPercent = downAmounts[0];
      int downAmountDollar = downAmounts[1];
      loanAmount = price - downAmountDollar;
      if (loanAmount >= 0 && downAmountPercent <= 100) {
        labelDownAmount = getLabelDownAmount(downAmounts, _downType);
        labelLoanAmount = getLabelLoanAmount(loanAmount);
      } else {
        loanAmount = null;
      }
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Loan Calculator'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.96),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: loanSection(labelDownAmount, labelLoanAmount),
                ),
                Expanded(
                  flex: 2,
                  child: detailSection(),
                ),
                Expanded(
                  flex: 1,
                  child: outputSection(loanAmount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column loanSection(String labelDownAmount, String labelLoanAmount) {
    return Column(
      children: [
        LabelledRow(label: 'Price', maxLength: 10, controller: _price),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: LabelledRow(
                  label: 'Down',
                  maxLength: _downType == 0 ? 3 : 10,
                  controller: _down),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: DropdownButton(
                  dropdownColor: Colors.yellow[50],
                  value: _downType,
                  items: [
                    DropdownMenuItem(
                      value: 0,
                      child: Text(
                        '%',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text(
                        '\$',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _down.text = '0';
                        _downType = value;
                        resetOutputs();
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        Text(
          labelDownAmount,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          labelLoanAmount,
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }

  Column detailSection() {
    return Column(
      children: [
        InputRow(
          label: 'Loan term [months]',
          maxLength: 3,
          controller: _term,
          formatToInt: true,
          selectableFrequency: false,
        ),
        InputRow(
          label: 'Interest rate [annual %]',
          maxLength: 6,
          controller: _rate,
          formatToInt: false,
          selectableFrequency: false,
        ),
        InputRow(
          label: 'Property tax [\$]',
          maxLength: 7,
          controller: _tax,
          formatToInt: true,
          selectableFrequency: true,
          dropdownValue: _frequencyTax,
          callback: (int value) {
            setState(() {
              _frequencyTax = value;
              resetOutputs();
            });
          },
        ),
        InputRow(
          label: 'Insurance [\$]',
          maxLength: 7,
          controller: _insurance,
          formatToInt: true,
          selectableFrequency: true,
          dropdownValue: _frequencyInsurance,
          callback: (int value) {
            setState(() {
              _frequencyInsurance = value;
              resetOutputs();
            });
          },
        ),
        InputRow(
          label: 'HOA [\$]',
          maxLength: 7,
          controller: _hoa,
          formatToInt: true,
          selectableFrequency: true,
          hasQuarterly: true,
          dropdownValue: _frequencyHoa,
          callback: (int value) {
            setState(() {
              _frequencyHoa = value;
              resetOutputs();
            });
          },
        ),
        InputRow(
          label: 'Monthly PMI [\$]',
          maxLength: 7,
          controller: _pmi,
          formatToInt: true,
          selectableFrequency: false,
        ),
      ],
    );
  }

  Column outputSection(int? loanAmount) {
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

  void calculate(int loanAmount) {
    int p0 = loanAmount;
    int? N = validateInputInt(_term.text);
    double? R = validateInputDouble(_rate.text);
    int? qTax = validateInputInt(_tax.text);
    int? qInsurance = validateInputInt(_insurance.text);
    int? qHoa = validateInputInt(_hoa.text);
    int? qPmi = validateInputInt(_pmi.text);
    if (N != null &&
        R != null &&
        qTax != null &&
        qInsurance != null &&
        qHoa != null &&
        qPmi != null) {
      if (R > 0) {
        double r = R / 100;
        double Q = computeQ(p0, r, N);
        setState(() {
          _roundedQ = double.parse(Q.toStringAsFixed(2));
          _monthlyPayment = calculatePayment(Q, qTax, qInsurance, qHoa, qPmi,
              _frequencyTax, _frequencyInsurance, _frequencyHoa);
          _totalPI = _roundedQ * N;
          _totalInterest = _totalPI - p0;
        });
        // Use the below for amortization table
        _sequenceDP = getSequenceDP(getSequenceP(p0, r, Q, N));
        _sequenceDI = _sequenceDP.map((e) => Q - e).toList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Interest rate must be > 0'),
          duration: Duration(seconds: 1),
        ));
      }
    }
  }

  void resetInputs() {
    _price.text = '0';
    _down.text = '0';
    _downType = 0;
    _term.text = '360';
    _rate.text = '0';
    _tax.text = '0';
    _insurance.text = '0';
    _hoa.text = '0';
    _pmi.text = '0';
    _frequencyTax = 0;
    _frequencyInsurance = 0;
    _frequencyHoa = 0;
  }

  void resetOutputs() {
    _roundedQ = 0;
    _monthlyPayment = 0;
    _totalInterest = 0;
    _totalPI = 0;
    _sequenceDP = [];
    _sequenceDI = [];
  }

  void resetStates() {
    setState(() {
      resetInputs();
      resetOutputs();
    });
  }
}
