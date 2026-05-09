import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_calculator/models/escrow.dart';
import 'package:loan_calculator/models/loan.dart';
import 'package:loan_calculator/models/price.dart';
import 'package:loan_calculator/providers/escrow_provider.dart';
import 'package:loan_calculator/providers/price_provider.dart';
import 'package:loan_calculator/widgets/form_escrow.dart';
import 'package:loan_calculator/widgets/form_price.dart';
import 'package:loan_calculator/widgets/section_results.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Price price = ref.watch(priceNotifierProvider);

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
                  const Expanded(
                    flex: 1,
                    child: FormPrice(),
                  ),
                  Expanded(
                    flex: 2,
                    child: price.isValid() ? const FormEscrow() : Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Consumer(
                      builder: (BuildContext context, WidgetRef ref, Widget? child) {
                        Escrow escrow = ref.read(escrowNotifierProvider);

                        if (price.isValid()) {


                        } else {
                          return Container();
                        }

                        Loan loan = Loan.fromControllers(
                          principal: price.cost!,
                          controllerRate: _controllerRate,
                          controllerTerm: _controllerTerm,
                          escrow: escrow,
                        );
                        if (loan.isValid()) {
                          widget.onUpdateLoan(loan);
                        }

                        return _loan == null
                            ? Container()
                            : SectionResults(
                                loan: _loan!,
                              );
                      }
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
