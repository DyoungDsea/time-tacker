import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_1/app/home/models.dart';
import 'package:flutter_1/common_widgets/show_alert_dialog.dart';
import 'package:flutter_1/common_widgets/show_exception_alert.dart';
import 'package:flutter_1/services/auth.dart';
import 'package:flutter_1/services/database.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Can't logout",
        exception: e,
      );
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: "Logout",
      content: "Are you sure you want to logout?",
      defaulActionText: "Ok",
      cancelActionText: "Cancel",
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: "Blogging", ratePerHour: 10));
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Operation Fail",
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jobs"),
        actions: <Widget>[
          TextButton(
              onPressed: () => _confirmSignOut(context),
              child: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ))
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createJob(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jobs = snapshot.data;
            final children = jobs!.map((job) => Text(job.name)).toList();
            return ListView(
              children: children,
            );
          }
          return const Center(child:CircularProgressIndicator());
        });
  }
}
