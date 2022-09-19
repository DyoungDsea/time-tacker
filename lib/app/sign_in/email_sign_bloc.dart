import 'dart:async';

import 'package:flutter_1/app/sign_in/email_sign_in_module.dart';
import 'package:flutter_1/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});
  AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

void toggleButtonType(){
  final formType = _model.formType == EmailSignInFormType.signIn
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


  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool isLoading = false,
    bool submitted = false,
  }) {
    //update model
    _model = _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        submitted: submitted);

    // add updated model to _modelController
    _modelController.add(_model);
  }
}
