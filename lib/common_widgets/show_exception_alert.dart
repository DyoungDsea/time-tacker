import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_1/common_widgets/show_alert_dialog.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required Exception exception,
}) =>
    showAlertDialog(
      context,
      title: title,
      content:_message(exception),
      defaulActionText: "Ok",
    );

String _message(Exception exception) {
  if (exception is FirebaseException) {
    return exception.message.toString();
  }
  return exception.toString();
}
