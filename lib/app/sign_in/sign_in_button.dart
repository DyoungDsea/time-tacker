import 'package:flutter/cupertino.dart';
import 'package:flutter_1/common_widgets/elevation_button.dart';

class SignInButton extends CustomElevationButton {
  SignInButton({
    Key? key,
    required String text,
    required Color primaryColor,
    required Color onPrimaryColor,
     VoidCallback? onPressed,
  }) : super(
          key: key,
          primaryColor: primaryColor,
          onPrimaryColor: onPrimaryColor,
          onPressed: onPressed,
          child: Text(text),
        );
}
