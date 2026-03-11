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
  late Price _price;

  @override
  void initState() {
    super.initState();
    widget.controllerPrice.addListener(() => setState(() {}));
    widget.controllerDown.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    _price = Price.fromControllers(
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
                  maxLength: _isDownPercentage ? 2 : 10,
                  controller: widget.controllerDown),
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
                        widget.controllerDown.text = '0';
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
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    _price.labelDownAmount,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    _price.labelCostAmount,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  if (_price.isValid()) {
                    widget.onUpdatePrice(_price);
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
