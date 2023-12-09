import 'package:distance_range_estimator/types/constants.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onPressed;
  final bool isDisabled;

  const DefaultButton({
    super.key,
    required this.btnText,
    required this.onPressed,
    this.isDisabled = false, // Default is false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: kLessPadding),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: TextButton(
        onPressed: isDisabled ? null : onPressed, // Disable if isDisabled is true
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: kLessPadding),
          backgroundColor: isDisabled ? Colors.grey : kPrimaryColor, // Optional: Change color when disabled
          foregroundColor: kRevColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultRad),
          ),
        ),
        child: Text(
          btnText.toUpperCase(),
          style: TextStyle(
            color: isDisabled ? Colors.black45 : Colors.white, // Optional: Change text color when disabled
          ),
        ),
      ),
    );
  }
}
