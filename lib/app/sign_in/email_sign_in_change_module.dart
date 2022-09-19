import 'package:flutter/foundation.dart';
import 'package:flutter_1/app/sign_in/email_sign_in_module.dart';
import 'package:flutter_1/app/sign_in/validator.dart';
import 'package:flutter_1/services/auth.dart';

// enum EmailSignInFormType { signIn, register }

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
    required this.auth
  });

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? "Sign In"
        : "Create an account";
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? "Need an account? Register"
        : "Already have an account? Sign In";
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String? get passwordErrorText {
    final showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? isValidPasswordErrorText : null;
  }

  String? get emailErrorText {
    final showErrorText = submitted && !emailValidator.isValid(password);
    return showErrorText ? isValidEmailErrorText : null;
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleButtonType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith(
      {String? email,
      String? password,
      EmailSignInFormType? formType,
      bool? isLoading,
      bool? submitted}) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
