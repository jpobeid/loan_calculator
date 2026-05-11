import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_calculator/models/terms.dart';
import 'package:loan_calculator/providers/terms_provider.dart';
import 'package:loan_calculator/widgets/input_widgets.dart';

class FormTerms extends ConsumerStatefulWidget {
  const FormTerms({
    super.key,
  });

  @override
  ConsumerState<FormTerms> createState() => _FormTermsState();
}

class _FormTermsState extends ConsumerState<FormTerms> {
  final TextEditingController _controllerTime = TextEditingController();
  final TextEditingController _controllerRatePercent = TextEditingController();
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    Terms terms = ref.read(termsNotifierProvider);
    _controllerTime.text = terms.time.toString();
    _controllerRatePercent.text = terms.ratePercent.toString();

    _controllers = [
      _controllerTime,
      _controllerRatePercent,
    ];
    for (TextEditingController e in _controllers) {
      e.addListener(() => setState(() {
            ref.read(termsNotifierProvider.notifier).updateFromControllers(
                  controllerTime: _controllerTime,
                  controllerRatePercent: _controllerRatePercent,
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
          controller: _controllerTime,
          formatToInt: true,
          selectableFrequency: false,
        ),
        InputRow(
          label: 'Interest rate [annual %]',
          maxLength: 6,
          controller: _controllerRatePercent,
          formatToInt: false,
          selectableFrequency: false,
        ),
      ],
    );
  }
}
