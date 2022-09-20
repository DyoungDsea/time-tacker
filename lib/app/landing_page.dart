import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_1/app/home/jobs/jobs_page.dart';
import 'package:flutter_1/app/sign_in/sign_in_page.dart';
import 'package:flutter_1/services/auth.dart';
import 'package:flutter_1/services/database.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
        stream: auth.authStategChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }
            return Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              child:const JobsPage(),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
