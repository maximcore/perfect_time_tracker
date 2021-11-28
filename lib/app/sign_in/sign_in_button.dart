import 'package:flutter/material.dart';
import 'package:perfect_time_tracker/common_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    Key key,
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          key: key,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16.0,
            ),
          ),
          color: color,
          onPressed: onPressed,
        );
}
