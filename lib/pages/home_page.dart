import 'package:flutter/material.dart';
import 'package:loan_calculator/models/loan.dart';
import 'package:loan_calculator/models/price.dart';
import 'package:loan_calculator/widgets/form_escrow.dart';
import 'package:loan_calculator/widgets/form_price.dart';
import 'package:loan_calculator/widgets/section_results.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controllerPrice =
      TextEditingController(text: '0');
  final TextEditingController _controllerDown =
      TextEditingController(text: '0');
  Price? _price;
  Loan? _loan;

  @override
  void dispose() {
    _controllerPrice.dispose();
    _controllerDown.dispose();
    super.dispose();
  }

  void _resetState() {
    if (_loan == null) {
      setState(() {
        _controllerPrice.text = '0';
        _controllerDown.text = '0';
        _price = null;
      });
    } else {
      setState(() {
        _loan = null;
      });
    }
  }

  void _updatePrice(Price? price) {
    setState(() {
      _price = price;
    });
  }

  void _updateLoan(Loan loan) {
    setState(() {
      _loan = loan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Loan Calculator'),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              onPressed: _resetState,
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.red,
              ),
            ),
          ],
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
                        onUpdatePrice: _updatePrice,
                        controllerPrice: _controllerPrice,
                        controllerDown: _controllerDown,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _price == null
                        ? Container()
                        : IgnorePointer(
                            ignoring: _loan != null,
                            child: FormEscrow(
                              price: _price!,
                              onUpdateLoan: _updateLoan,
                            ),
                          ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _loan == null
                        ? Container()
                        : SectionResults(
                            loan: _loan!,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
