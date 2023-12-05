import 'package:distance_range_estimator/types/constants.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onPressed;
  const DefaultButton({
    super.key,
    required this.btnText,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: TextButton(
        
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: kLessPadding),
          backgroundColor: kPrimaryColor,
          foregroundColor: kRevColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultRad),
          ),
          // shape: Roun
        ),
        child: Text(btnText.toUpperCase()),
      ),
    );
  }
}