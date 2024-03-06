/*
 * Copyright (c) 2022 .
 */

import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneFieldWidget extends StatelessWidget {
  const PhoneFieldWidget(
      {Key key,
      this.onSaved,
      this.onChanged,
      this.initialValue,
      this.hintText,
      this.errorText,
      this.labelText,
      this.obscureText,
      this.suffixIcon,
      this.isFirst,
      this.isLast,
      this.style,
      this.textAlign,
      this.suffix,
      this.initialCountryCode,
      this.countries,
      this.onCountryChanged})
      : super(key: key);

  final FormFieldSetter<PhoneNumber> onSaved;
  final ValueChanged<PhoneNumber> onChanged;
  final String initialValue;
  final String hintText;
  final String errorText;
  final TextAlign textAlign;
  final void Function(Country) onCountryChanged;
  final String labelText;
  final TextStyle style;
  final bool obscureText;
  final String initialCountryCode;
  final List<String> countries;
  final bool isFirst;
  final bool isLast;
  final Widget suffixIcon;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
        invalidNumberMessage: "الرقم غير صالح",
        key: key,
        onSaved: onSaved,
        onChanged: onChanged,
        onCountryChanged: onCountryChanged,
        countries: const ["EG", "SA", "AE", "OM", "BH", "QA", "KW"],
        initialValue: initialValue ?? '',
        initialCountryCode: initialCountryCode ?? 'SA',
        showDropdownIcon: true,
        //   pickerDialogStyle:
        //    PickerDialogStyle(countryNameStyle: Get.textTheme.bodyText2),
        //  style: style ?? Get.textTheme.bodyText2,
        textAlign: textAlign ?? TextAlign.start,
        disableLengthCheck: false,
        autovalidateMode: AutovalidateMode.disabled,
        decoration: InputDecoration(
          hintText: hintText ?? '',
          //          hintStyle: Get.textTheme.caption,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.all(0),
          border: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.black,
          )),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.black,
          )),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.black,
          )),
          suffixIcon: suffixIcon,
          suffix: suffix,
          errorText: errorText,
        ));
  }

  BorderRadius get buildBorderRadius {
    if (isFirst != null && isFirst) {
      return const BorderRadius.vertical(top: Radius.circular(10));
    }
    if (isLast != null && isLast) {
      return const BorderRadius.vertical(bottom: Radius.circular(10));
    }
    if (isFirst != null && !isFirst && isLast != null && !isLast) {
      return const BorderRadius.all(Radius.circular(0));
    }
    return const BorderRadius.all(Radius.circular(10));
  }

  double get topMargin {
    if ((isFirst != null && isFirst)) {
      return 20;
    } else if (isFirst == null) {
      return 20;
    } else {
      return 0;
    }
  }

  double get bottomMargin {
    if ((isLast != null && isLast)) {
      return 10;
    } else if (isLast == null) {
      return 10;
    } else {
      return 0;
    }
  }
}
