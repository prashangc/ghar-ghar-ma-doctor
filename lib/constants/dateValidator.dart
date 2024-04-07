import 'package:flutter/services.dart';

class MyDateInputFormatter extends TextInputFormatter {
  final String _placeholder = '----/--/--';
  TextEditingValue? _lastNewValue;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.length >= newValue.text.length) {
      return newValue;
    }
    newValue = newValue.copyWith(
      text: _fillInputToPlaceholder(newValue.text),
    );
    var dateText = _addSeparator(newValue.text, '-');
    return newValue.copyWith(
        text: dateText, selection: updateCursorPosition(dateText));
  }

  String _addSeparator(String value, String separator) {
    value = value.replaceAll('-', '');
    var newString = '';
    for (int i = 0; i < value.length; i++) {
      newString += value[i];
      if (i == 3) {
        newString += separator;
      }
      if (i == 5) {
        newString += separator;
      }
    }
    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  String _fillInputToPlaceholder(String? input) {
    print(input);

    //   if (input == null || input.isEmpty) {
    //     return _placeholder;
    //   }
    //   final index = [0, 1, 3, 4, 6, 7, 8, 9];
    //   final length = min(index.length, input.length);
    //   for (int i = 0; i < length; i++) {
    //     result = result.replaceRange(index[i], index[i] + 1, input[i]);
    //   }
    return input!;
  }
}
