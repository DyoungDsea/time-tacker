import 'package:flutter/material.dart';
import 'package:flutter_1/common_widgets/elevation_button.dart';

class FormSubmitButton extends CustomElevationButton {
  FormSubmitButton({
    Key? key,
    required String text,
     VoidCallback ? onPressed,
  }) : super(
            key: key,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            primaryColor: Colors.indigo,
            onPrimaryColor: Colors.white,
            onPressed: onPressed);
}
