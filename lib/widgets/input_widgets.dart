import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_calculator/data/constants.dart';

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
  final Frequency? dropdownValue;
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
          value: Frequency.monthly,
          child: Text(
            Frequency.monthly.label,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        DropdownMenuItem(
          value: Frequency.annually,
          child: Text(
            Frequency.annually.label,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ];
      if (hasQuarterly != null) {
        if (hasQuarterly!) {
          dropdownItems.add(DropdownMenuItem(
            value: Frequency.quarterly,
            child: Text(
              Frequency.quarterly.label,
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
