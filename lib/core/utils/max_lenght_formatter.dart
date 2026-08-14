import 'package:flutter/services.dart';

class MaxLengthFormatter extends TextInputFormatter {
  final int maxLength;

  MaxLengthFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length <= maxLength) {
      return newValue;
    }

    final trimmedText = newValue.text.substring(0, maxLength);

    return TextEditingValue(
      text: trimmedText,
      selection: TextSelection.collapsed(offset: maxLength),
    );
  }
}
