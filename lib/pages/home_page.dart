import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_calculator/models/escrow.dart';
import 'package:loan_calculator/models/loan.dart';
import 'package:loan_calculator/models/price.dart';
import 'package:loan_calculator/models/terms.dart';
import 'package:loan_calculator/providers/escrow_provider.dart';
import 'package:loan_calculator/providers/price_provider.dart';
import 'package:loan_calculator/providers/terms_provider.dart';
import 'package:loan_calculator/widgets/form_escrow.dart';
import 'package:loan_calculator/widgets/form_price.dart';
import 'package:loan_calculator/widgets/form_terms.dart';
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
              onPressed: () {
                ref.read(priceNotifierProvider.notifier).resetState();
                ref.read(termsNotifierProvider.notifier).resetState();
                ref.read(escrowNotifierProvider.notifier).resetState();
              },
              icon: const Icon(
                Icons.restart_alt,
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
                    child: Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                        Terms terms = ref.watch(termsNotifierProvider);

                        List<Widget> forms = [];
                        if (price.isValid()) {
                          forms.add(const FormTerms());
                          if (terms.isValid()) {
                            forms.add(const FormEscrow());
                          }
                        }
                        if (forms.isEmpty) {
                          return Container();
                        } else {
                          return Column(
                            children: forms,
                          );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                        Terms terms = ref.watch(termsNotifierProvider);
                        Escrow escrow = ref.watch(escrowNotifierProvider);

                        if (price.isValid() && terms.isValid()) {
                          Loan loan = Loan(
                            principal: price.cost!,
                            terms: terms,
                            escrow: escrow,
                          );
                          return SectionResults(loan: loan);
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
