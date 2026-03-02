import 'package:flutter/material.dart';
import 'package:loan_calculator/models/price.dart';
import 'package:loan_calculator/widgets/form_escrow.dart';
import 'package:loan_calculator/widgets/form_price.dart';
import 'package:loan_calculator/widgets/section_results.dart';
import 'package:loan_calculator/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Inputs
  final TextEditingController _controllerPrice =
      TextEditingController(text: '0');
  final TextEditingController _controllerDown =
      TextEditingController(text: '0');
  final TextEditingController _controllerTerm =
      TextEditingController(text: '360');
  final TextEditingController _controllerRate =
      TextEditingController(text: '0');
  final TextEditingController _controllerTax = TextEditingController(text: '0');
  final TextEditingController _controllerInsurance =
      TextEditingController(text: '0');
  final TextEditingController _controllerHoa = TextEditingController(text: '0');
  final TextEditingController _controllerPmi = TextEditingController(text: '0');

  Price? _price;

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

  // ###
  // @override
  // void initState() {
  //   super.initState();
  //   List<TextEditingController> controllers = [
  //     _controllerPrice,
  //     _controllerDown,
  //     _controllerTerm,
  //     _controllerRate,
  //     _controllerTax,
  //     _controllerInsurance,
  //     _controllerHoa,
  //     _controllerPmi,
  //   ];
  //   for (TextEditingController controller in controllers) {
  //     controller.addListener(() {
  //       setState(() {
  //         resetOutputs();
  //       });
  //     });
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    List<TextEditingController> controllers = [
      _controllerPrice,
      _controllerDown,
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
  }

  void _updatePrice(Price price) {
    _price = price;
  }

  void _updateFrequencies({
    required int frequencyTax,
    required int frequencyInsurance,
    required int frequencyHoa,
  }) {
    _frequencyTax = frequencyTax;
    _frequencyInsurance = frequencyInsurance;
    _frequencyHoa = frequencyHoa;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Loan Calculator'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.95,
                maxWidth: MediaQuery.of(context).size.width * 0.95,
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: IgnorePointer(
                      ignoring: _price != null,
                      child: FormPrice(
                        controllerPrice: _controllerPrice,
                        controllerDown: _controllerDown,
                        onUpdatePrice: _updatePrice,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _price == null
                        ? Container()
                        : FormEscrow(
                            controllerTerm: _controllerTerm,
                            controllerRate: _controllerRate,
                            controllerTax: _controllerTax,
                            controllerInsurance: _controllerInsurance,
                            controllerHoa: _controllerHoa,
                            controllerPmi: _controllerPmi,
                            frequencyTax: _frequencyTax,
                            frequencyInsurance: _frequencyInsurance,
                            frequencyHoa: _frequencyHoa,
                            onUpdateFrequencies: _updateFrequencies,
                          ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _price == null ? Container() : SectionResults(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
