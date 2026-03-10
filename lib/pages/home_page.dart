import 'package:flutter/material.dart';
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
  Price? _price;

  void _resetState() {
    setState(() {
      _price = null;
    });
  }

  void _updatePrice(Price price) {
    print('here');
    setState(() {
      _price = price;
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
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _price == null
                        ? Container()
                        : FormEscrow(
                            price: _price!,
                          ),
                  ),
                  Expanded(
                    flex: 1,
                    child:
                        _price == null ? Container() : const SectionResults(),
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
