import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_1/app/sign_in/email_sign_bloc.dart';
import 'package:flutter_1/app/sign_in/email_sign_in_module.dart';
import 'package:flutter_1/common_widgets/form_submit_button.dart';
import 'package:flutter_1/common_widgets/show_exception_alert.dart';
import 'package:flutter_1/services/auth.dart';
import 'package:provider/provider.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({Key? key, required this.bloc}) : super(key: key);
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<EmailSignInFormBlocBased> createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "sign in Failed!",
        exception: e,
      );
    }
  }

  void _editingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleButton() {
    widget.bloc.toggleButtonType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailText(model),
      const SizedBox(height: 16),
      _buildEmailPassword(model),
      const SizedBox(height: 16),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      const SizedBox(height: 16),
      TextButton(
        onPressed: !model.isLoading ? _toggleButton : null,
        child: Text(model.secondaryButtonText),
      ),
    ];
  }

  TextField _buildEmailText(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "test@g mail.com",
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.next,
      onChanged: widget.bloc.updateEmail,
      onEditingComplete: () => _editingComplete(model),
    );
  }

  TextField _buildEmailPassword(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "****",
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.done,
      onChanged: widget.bloc.updatePassword,
      onEditingComplete: _submit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildChildren(model),
            ),
          );
        });
  }
}
