import 'package:flutter/material.dart';
import 'package:loan_calculator/models/price.dart';
import 'package:loan_calculator/widgets/widgets.dart';

class FormPrice extends StatefulWidget {
  final void Function(Price price) onUpdatePrice;

  const FormPrice({
    super.key,
    required this.onUpdatePrice,
  });

  @override
  State<FormPrice> createState() => _FormPriceState();
}

class _FormPriceState extends State<FormPrice> {
  final TextEditingController _controllerPrice =
      TextEditingController(text: '0');
  final TextEditingController _controllerDown =
      TextEditingController(text: '0');
  bool _isDownPercentage = true;

  @override
  void dispose() {
    List<TextEditingController> controllers = [
      _controllerPrice,
      _controllerDown,
    ];
    for (TextEditingController e in controllers) {
      e.dispose();
    }
    super.dispose();
  }

  void _resetState() {
    _controllerPrice.text = '0';
    _controllerDown.text = '0';
    _isDownPercentage = true;
  }

  @override
  Widget build(BuildContext context) {
    print('in form price');
    Price price = Price.fromControllers(
      controllerPrice: _controllerPrice,
      controllerDown: _controllerDown,
      isDownPercentage: _isDownPercentage,
    );
    print(price.price);
    print(price.cost);

    return Column(
      children: [
        LabelledRow(
            label: 'Price', maxLength: 10, controller: _controllerPrice),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: LabelledRow(
                  label: 'Down',
                  maxLength: _isDownPercentage ? 3 : 10,
                  controller: _controllerDown),
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
                        _controllerDown.text = '0';
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
                  print('pressing button');
                  if (price.isValid()) {
                    print(price.toString());
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
