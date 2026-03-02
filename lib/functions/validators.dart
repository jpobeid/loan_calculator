int? validateInputInt(String textNumber) {
  try {
    int number = int.parse(textNumber.replaceAll(',', ''));
    return number;
  } catch (e) {
    return null;
  }
}

double? validateInputDouble(String textNumber) {
  try {
    double number = double.parse(textNumber.replaceAll(',', ''));
    return number;
  } catch (e) {
    return null;
  }
}
