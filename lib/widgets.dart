import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_calculator/amortization.dart';

void formatTextToInt(String value, TextEditingController controller) {
  final String sanitizedValue = value.replaceAll(',', '').replaceAll('.', '');
  final int intValue = int.tryParse(sanitizedValue) ?? 0;

  // Format the integer with commas and update the text field
  final String formattedValue = NumberFormat('#,###').format(intValue);
  controller.value = TextEditingValue(
    text: formattedValue,
    selection: TextSelection.collapsed(offset: formattedValue.length),
  );
}

void formatTextToDouble(String value, TextEditingController controller) {
  final String sanitizedValue =
      value.replaceAll(',', '').replaceAll(' ', '').replaceAll('-', '');
  String formattedValue = sanitizedValue;
  if (formattedValue.isEmpty) {
    formattedValue = '0';
  } else if (formattedValue.length > 1 &&
      formattedValue.startsWith('0') &&
      !formattedValue.startsWith('0.')) {
    formattedValue = value.substring(1);
  } else if (formattedValue.indexOf('.') != formattedValue.lastIndexOf('.')) {
    formattedValue = value.substring(0, formattedValue.length - 1);
  }
  controller.value = TextEditingValue(
    text: formattedValue,
    selection: TextSelection.collapsed(offset: formattedValue.length),
  );
}

class LabelledRow extends StatelessWidget {
  final String label;
  final int maxLength;
  final TextEditingController controller;

  const LabelledRow(
      {super.key,
      required this.label,
      required this.maxLength,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 1,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            )),
        Expanded(
          flex: 1,
          child: TextField(
            decoration: const InputDecoration(
              counterText: '',
              isDense: true,
              isCollapsed: true,
            ),
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: maxLength,
            style: Theme.of(context).textTheme.bodyMedium,
            onChanged: (value) {
              formatTextToInt(value, controller);
            },
          ),
        ),
      ],
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final int maxLength;
  final TextEditingController controller;
  final bool formatToInt;

  const InputField({
    super.key,
    required this.label,
    required this.maxLength,
    required this.controller,
    required this.formatToInt,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        counterText: ' ',
        contentPadding: const EdgeInsets.all(3),
        border: const OutlineInputBorder(),
        labelText: label,
        isDense: true,
        labelStyle: Theme.of(context).textTheme.labelSmall,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      keyboardType: TextInputType.number,
      maxLength: maxLength,
      controller: controller,
      onChanged: (value) {
        if (formatToInt) {
          formatTextToInt(value, controller);
        } else {
          formatTextToDouble(value, controller);
        }
      },
    );
  }
}

class InputRow extends StatelessWidget {
  final String label;
  final int maxLength;
  final TextEditingController controller;
  final bool formatToInt;
  final bool selectableFrequency;
  final bool? hasQuarterly;
  final int? dropdownValue;
  final Function? callback;

  const InputRow({
    super.key,
    required this.label,
    required this.maxLength,
    required this.controller,
    required this.formatToInt,
    required this.selectableFrequency,
    this.hasQuarterly,
    this.dropdownValue,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> dropdownItems = [];
    if (selectableFrequency) {
      dropdownItems = [
        DropdownMenuItem(
          value: 0,
          child: Text(
            'monthly',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        DropdownMenuItem(
          value: 1,
          child: Text(
            'yearly',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ];
      if (hasQuarterly != null) {
        if (hasQuarterly!) {
          dropdownItems.add(DropdownMenuItem(
            value: 2,
            child: Text(
              'quarterly',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ));
        }
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: InputField(
              label: label,
              maxLength: maxLength,
              controller: controller,
              formatToInt: formatToInt),
        ),
        selectableFrequency
            ? Expanded(
                flex: 2,
                child: Center(
                  child: DropdownButton(
                    dropdownColor: Colors.yellow[50],
                    value: dropdownValue,
                    items: dropdownItems,
                    onChanged: (value) {
                      if (callback != null) {
                        callback!(value);
                      }
                    },
                  ),
                ),
              )
            : Expanded(flex: 2, child: Container()),
      ],
    );
  }
}

class OutputColumn extends StatelessWidget {
  final double roundedQ;
  final double monthlyPayment;
  final double totalInterest;
  final double totalPI;
  final List<double> sequenceDP;
  final List<double> sequenceDI;

  const OutputColumn({
    super.key,
    required this.roundedQ,
    required this.monthlyPayment,
    required this.totalInterest,
    required this.totalPI,
    required this.sequenceDP,
    required this.sequenceDI,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Monthly payment [\$]: ${NumberFormat('#,###.##').format(monthlyPayment)}',
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
        Text(
          'Monthly P&I [\$]: ${NumberFormat('#,###.##').format(roundedQ)}',
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
        IconButton(
          icon: const Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.purple,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return InfoDialog(
                    roundedQ: roundedQ,
                    monthlyPayment: monthlyPayment,
                    totalInterest: totalInterest,
                    totalPI: totalPI,
                    sequenceDP: sequenceDP,
                    sequenceDI: sequenceDI,
                  );
                });
          },
        ),
      ],
    );
  }
}

class InfoDialog extends StatelessWidget {
  final double roundedQ;
  final double monthlyPayment;
  final double totalInterest;
  final double totalPI;
  final List<double> sequenceDP;
  final List<double> sequenceDI;

  const InfoDialog({
    super.key,
    required this.roundedQ,
    required this.monthlyPayment,
    required this.totalInterest,
    required this.totalPI,
    required this.sequenceDP,
    required this.sequenceDI,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Loan details'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Monthly payment [\$]: ${NumberFormat('#,###.##').format(monthlyPayment)}',
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
            Text(
              'Monthly P&I [\$]: ${NumberFormat('#,###.##').format(roundedQ)}',
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
            Text(
              'Total interest paid [\$]: ${NumberFormat('#,###.##').format(totalInterest)}',
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
            Text(
              'Total P&I paid [\$]: ${NumberFormat('#,###.##').format(totalPI)}',
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Amortization'),
          onPressed: () {
            if (roundedQ < 10) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payments too low (rounding errors)'),
                  duration: Duration(milliseconds: 500),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Amortization(
                    sequenceDP: sequenceDP,
                    sequenceDI: sequenceDI,
                  ),
                ),
              );
            }
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
