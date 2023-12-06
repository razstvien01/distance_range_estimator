import 'package:distance_range_estimator/types/constants.dart';
import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  //* variables
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final validator;
  final keyboardType, obscureText;
  int maxLines;
  VoidCallback? isObscure;

  DefaultTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    this.obscureText = false,
    this.isObscure,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultFontSize),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(kDefaultRad),
        ),
        color: kBGColor,
      ),
      child: TextFormField(
        //maxLines: null,
        minLines: 1,
        maxLines: maxLines,
        validator: validator,
        controller: controller,
        cursorColor: kPrimaryColor,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          errorStyle: TextStyle(color: kPrimaryColor),
          hintText: hintText,
          hintStyle: kSmallTextStyle,
          iconColor: kPrimaryColor,
          fillColor: kAccentColor,
          icon: Icon(
            icon,
            color: kRevColor,
          ),
          suffixIcon: (TextInputType.visiblePassword == keyboardType)
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: isObscure,
                )
              : null,
        ),
        style: kSmallTextStyle,
        obscureText: obscureText,
      ),
    );
  }
}
