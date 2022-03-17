import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FieldType {
  name,
  age,
  phoneNumber,
  creditCardNumber,
  creditCardDueTo,
  creditCardCVV,
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.controller,
    required this.fieldType,
    this.label,
    this.showError = false,
  }) : super(key: key);

  final TextEditingController controller;
  final FieldType fieldType;
  final String? label;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: fieldType == FieldType.name
            ? TextInputType.name
            : TextInputType.number,
        inputFormatters: getInputFieldFormatters(),
        decoration: InputDecoration(
          label: label != null ? Text(label!) : null,
          hintText: getHintText(),
          errorText: showError ? "$label is wrong" : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          suffixIcon: getSuffixIcon(),
        ),
        onChanged: onChanged,
      ),
    );
  }

  void onChanged(String value) {
    if (fieldType == FieldType.creditCardNumber && value.endsWith(" ") ||
        fieldType == FieldType.creditCardDueTo && value.endsWith("/")) {
      controller.text = value.substring(0, value.length - 1);
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
    }
  }

  List<TextInputFormatter> getInputFieldFormatters() {
    List<TextInputFormatter> inputFormatters = [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ];
    switch (fieldType) {
      case FieldType.name:
        inputFormatters = [LengthLimitingTextInputFormatter(32)];
        break;
      case FieldType.age:
        inputFormatters.add(
          LengthLimitingTextInputFormatter(3),
        );
        break;
      case FieldType.phoneNumber:
        inputFormatters.add(LengthLimitingTextInputFormatter(15));
        break;
      case FieldType.creditCardNumber:
        inputFormatters = [
          LengthLimitingTextInputFormatter(19),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
          MaskedTextInputFormatter(mask: "0000 0000 0000 0000", separator: " "),
        ];
        break;
      case FieldType.creditCardDueTo:
        inputFormatters = [
          LengthLimitingTextInputFormatter(5),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9\/]')),
          MaskedTextInputFormatter(mask: "00/00", separator: "/"),
        ];
        break;
      case FieldType.creditCardCVV:
        inputFormatters.addAll([
          LengthLimitingTextInputFormatter(3),
        ]);
        break;
    }
    return inputFormatters;
  }

  String? getHintText() {
    switch (fieldType) {
      // case FieldType.name:
      //   return "";
      // case FieldType.age:
      //   return "";
      // case FieldType.phoneNumber:
      //   return "";
      case FieldType.creditCardNumber:
        return "XXXX XXXX XXXX XXXX";
      case FieldType.creditCardDueTo:
        return "MM/YY";
      case FieldType.creditCardCVV:
        return "XXX";
      default:
        return null;
    }
  }

  Icon? getSuffixIcon() {
    switch (fieldType) {
      case FieldType.name:
        return const Icon(Icons.person);
      case FieldType.age:
        return const Icon(Icons.cake);
      case FieldType.phoneNumber:
        return const Icon(Icons.phone);
      case FieldType.creditCardNumber:
        return const Icon(Icons.credit_card);
      case FieldType.creditCardDueTo:
        return const Icon(Icons.calendar_month);
      case FieldType.creditCardCVV:
        return const Icon(Icons.security);
    }
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
