import 'package:flutter_1/app/sign_in/validator.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

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
    return showErrorText ? isValidPasswordErrorText: null;
  }

  String? get emailErrorText {
    final showErrorText = submitted && !emailValidator.isValid(password);
    return showErrorText ? isValidEmailErrorText: null;
  }

//create a copy of EmailSignInModel
  EmailSignInModel copyWith(
      {String? email,
      String? password,
      EmailSignInFormType? formType,
      bool? isLoading,
      bool? submitted}) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
