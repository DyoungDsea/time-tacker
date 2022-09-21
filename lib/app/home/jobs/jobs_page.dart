import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_1/app/home/jobs/edit_job_page.dart';
import 'package:flutter_1/app/home/jobs/empty_content.dart';
import 'package:flutter_1/app/home/jobs/job_list_tile.dart';
import 'package:flutter_1/app/home/jobs/list_item_builder.dart';
import 'package:flutter_1/app/home/models/models.dart';
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

  Future<void> _confirmSignOut(BuildContext context,
      [bool mounted = true]) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: "Logout",
      content: "Are you sure you want to logout?",
      defaulActionText: "Ok",
      cancelActionText: "Cancel",
    );
    if (didRequestSignOut == true) {
      if (!mounted) return;
      _signOut(context);
    }
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context, title: 'Operation fail', exception: e);
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
        onPressed: () => EditJobPage.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          return ListItemBuilder<Job>(
            snapshot: snapshot,
            itemBuilder: (context, job) => Dismissible(
              key: Key('job-${job.id}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _delete(context, job),
              child: JobListTile(
                job: job,
                onTap: () => EditJobPage.show(context, job: job),
              ),
            ),
          );
        });
  }
}
