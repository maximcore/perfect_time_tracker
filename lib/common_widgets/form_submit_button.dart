import 'package:flutter/material.dart';
import 'package:perfect_time_tracker/common_widgets/custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    Key key,
    @required String text,
    VoidCallback onPressed,
  }) : super(
          key: key,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          height: 36.0,
          borderRadius: 8.0,
          onPressed: onPressed,
        );
}
