import 'package:flutter/material.dart';

class CustomElevationButton extends StatelessWidget {
  const CustomElevationButton({
    Key? key,
    required this.child,
    required this.primaryColor,
    required this.onPrimaryColor,
    this.borderRadius = 4.0,
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final Color primaryColor;
  final Color onPrimaryColor;
  final double borderRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        fixedSize: const Size(100, 60),
        primary: primaryColor, // Background color
        onPrimary: onPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,      
      child: child,
    );
  }
}
