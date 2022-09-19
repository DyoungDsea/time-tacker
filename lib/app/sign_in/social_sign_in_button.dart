import 'package:flutter/material.dart';
import 'package:flutter_1/common_widgets/elevation_button.dart';

class SocialSignInButton extends CustomElevationButton {
  SocialSignInButton({
    Key? key,
    required String text,
    required String imagePath,
    required Color primaryColor,
    required Color onPrimaryColor,
     VoidCallback? onPressed,
  }) : super(
          key: key,
          primaryColor: primaryColor,
          onPrimaryColor: onPrimaryColor,
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(imagePath),
              Text(text),
              const Text(""),
            ],
          ),
        );
}
