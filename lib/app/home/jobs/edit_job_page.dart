import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_1/app/home/models/models.dart';
import 'package:flutter_1/common_widgets/show_alert_dialog.dart';
import 'package:flutter_1/common_widgets/show_exception_alert.dart';
import 'package:flutter_1/services/database.dart';
import 'package:provider/provider.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key? key, required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job? job;

  static Future<void> show(BuildContext context, {Job? job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditJobPage(
        database: database,
        job: job,
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  State<EditJobPage> createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((e) => e.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job?.name);
        }
        if (allNames.contains(_name)) {
          if (!mounted) return;
          showAlertDialog(
            context,
            title: "Name already taken",
            content: "Please choose a different job name",
            defaulActionText: "ok",
          );
        } else {
          final id = widget.job?.id ?? idFromDate();
          final job = Job(
            id: id,
            name: _name!,
            ratePerHour: _ratePerHour!,
          );
          await widget.database.setJob(job);
          if (!mounted) return;
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: "Operation failed!",
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? "New Job" : "Edit Job"),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: _submit,
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ))
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Job Name',
        ),
        validator: (value) => value!.isNotEmpty ? null : "Name can't be empty",
        onSaved: (value) => _name = value!,
        initialValue: _name,
      ),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Rate per hour',
        ),
        keyboardType: TextInputType.number,
        validator: (value) =>
            value!.isNotEmpty ? null : "Rate per hour can't be empty",
        onSaved: (value) => _ratePerHour = int.parse(value!),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
      )
    ];
  }
}
