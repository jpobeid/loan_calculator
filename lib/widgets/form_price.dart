import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_calculator/data/constants.dart';
import 'package:loan_calculator/models/price.dart';
import 'package:loan_calculator/providers/price_provider.dart';
import 'package:loan_calculator/widgets/input_widgets.dart';

class FormPrice extends ConsumerStatefulWidget {
  const FormPrice({
    super.key,
  });

  @override
  ConsumerState<FormPrice> createState() => _FormPriceState();
}

class _FormPriceState extends ConsumerState<FormPrice> {
  final TextEditingController _controllerPrice =
      TextEditingController(text: priceInitial.toString());
  final TextEditingController _controllerDown =
      TextEditingController(text: downInputtedInitial.toString());
  late List<TextEditingController> _controllers;
  bool _isDownPercentage = true;

  @override
  void initState() {
    super.initState();
    _controllers = [
      _controllerPrice,
      _controllerDown,
    ];
    for (TextEditingController e in _controllers) {
      e.addListener(() => setState(() {
            ref.read(priceNotifierProvider.notifier).updateFromControllers(
                  controllerPrice: _controllerPrice,
                  controllerDown: _controllerDown,
                  isDownPercentage: _isDownPercentage,
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
    Price price = ref.watch(priceNotifierProvider);

    return Column(
      children: [
        LabelledRow(
          label: 'Price',
          maxLength: 10,
          controller: _controllerPrice,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: LabelledRow(
                label: 'Down',
                maxLength: _isDownPercentage ? 2 : 10,
                controller: _controllerDown,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: DropdownButton(
                  dropdownColor: Colors.yellow[50],
                  value: _isDownPercentage,
                  items: [
                    DropdownMenuItem(
                      value: true,
                      child: Text(
                        '%',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: Text(
                        '\$',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        _controllerDown.text = downInputtedInitial.toString();
                        _isDownPercentage = value;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  price.labelDownAmount,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  price.labelCostAmount,
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
