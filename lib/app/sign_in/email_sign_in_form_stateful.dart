import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_1/app/sign_in/email_sign_in_module.dart';
import 'package:flutter_1/app/sign_in/validator.dart';
import 'package:flutter_1/common_widgets/form_submit_button.dart';
import 'package:flutter_1/common_widgets/show_exception_alert.dart';
import 'package:flutter_1/services/auth.dart';
import 'package:provider/provider.dart';

class EmailSignInFormStateful extends StatefulWidget
    with EmailAndPasswordValidators {
  EmailSignInFormStateful({Key? key}) : super(key: key);

  @override
  State<EmailSignInFormStateful> createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool submitted = false;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      submitted = true;
      isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Sign in failed!",
        exception: e,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _editingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleButton() {
    setState(() {
      submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
      _emailController.clear();
      _passwordController.clear();
    });
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? "Sign In"
        : "Create an account";
    final textButton = _formType == EmailSignInFormType.signIn
        ? "Need an account? Register"
        : "Already have an account? Sign In";

    bool submitEnable = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !isLoading;
    return [
      _buildEmailText(),
      const SizedBox(height: 16),
      _buildEmailPassword(),
      const SizedBox(height: 16),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnable ? _submit : null,
      ),
      const SizedBox(height: 16),
      TextButton(
        onPressed: !isLoading ? _toggleButton : null,
        child: Text(textButton),
      ),
    ];
  }

  TextField _buildEmailText() {
    bool showErrorText =
        submitted == true && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "test@gmail.com",
        errorText: showErrorText ? widget.isValidEmailErrorText : null,
        enabled: isLoading == false,
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: _editingComplete,
      onChanged: (email) => _updateState(),
    );
  }

  TextField _buildEmailPassword() {
    bool showErrorText =
        submitted == true && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "****",
        errorText: showErrorText ? widget.isValidPasswordErrorText : null,
        enabled: isLoading == false,
      ),
      textInputAction: TextInputAction.done,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }
}
