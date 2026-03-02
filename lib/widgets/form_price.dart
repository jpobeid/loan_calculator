import 'package:flutter/material.dart';
import 'package:loan_calculator/models/price.dart';
import 'package:loan_calculator/widgets/widgets.dart';

class FormPrice extends StatefulWidget {
  final TextEditingController controllerPrice;
  final TextEditingController controllerDown;
  final void Function(Price price) onUpdatePrice;

  const FormPrice({
    super.key,
    required this.controllerPrice,
    required this.controllerDown,
    required this.onUpdatePrice,
  });

  @override
  State<FormPrice> createState() => _FormPriceState();
}

class _FormPriceState extends State<FormPrice> {
  bool _isDownPercentage = true;

  @override
  Widget build(BuildContext context) {
    Price price = Price.fromControllers(
      controllerPrice: widget.controllerPrice,
      controllerDown: widget.controllerDown,
      isDownPercentage: _isDownPercentage,
    );

    return Column(
      children: [
        LabelledRow(
            label: 'Price', maxLength: 10, controller: widget.controllerPrice),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: LabelledRow(
                  label: 'Down',
                  maxLength: _isDownPercentage ? 3 : 10,
                  controller: widget.controllerDown),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: DropdownButton(
                  dropdownColor: Colors.yellow[50],
                  value: _isDownPercentage ? 0 : 1,
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
                        widget.controllerDown.text = '0';
                        _isDownPercentage = value == 0;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    price.labelDownAmount,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    price.labelCostAmount,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  if (price.isValid()) {
                    widget.onUpdatePrice(price);
                  }
                },
                icon: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
