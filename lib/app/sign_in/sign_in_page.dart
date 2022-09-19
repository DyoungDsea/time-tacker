import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_1/app/sign_in/email_sign_in_page.dart';
import 'package:flutter_1/app/sign_in/sign_in_manager.dart';
import 'package:flutter_1/app/sign_in/sign_in_button.dart';
import 'package:flutter_1/app/sign_in/social_sign_in_button.dart';
import 'package:flutter_1/common_widgets/show_exception_alert.dart';
import 'package:flutter_1/services/auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.manager, required this.isLoading})
      : super(key: key);
  final SignInManager manager;
  final bool isLoading;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(
            auth: auth,
            isLoading: isLoading,
          ),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == "ERROR_ABORTED_BY_USER") {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: "Sign in Failed",
      exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => const EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DyseaTech"),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          const SizedBox(
            height: 48.0,
          ),
          SocialSignInButton(
            text: "Sign in with Google",
            imagePath: "images/google-logo.png",
            primaryColor: Colors.white,
            onPrimaryColor: Colors.black,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          const SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            primaryColor: const Color(0xFF334D92),
            imagePath: "images/facebook-logo.png",
            onPrimaryColor: Colors.white,
            onPressed: () {},
            text: "Sign in with Facebook",
          ),
          const SizedBox(
            height: 8.0,
          ),
          SignInButton(
            primaryColor: Colors.teal,
            onPrimaryColor: Colors.white,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
            text: "Sign in with Email",
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Text(
            "OR",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          SignInButton(
            primaryColor: Colors.lime,
            onPrimaryColor: Colors.black,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
            text: "Go anonymous",
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text(
      "Sign In",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
