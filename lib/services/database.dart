import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_1/app/home/models.dart';
import 'package:flutter_1/services/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;

  @override
  Future<void> createJob(Job job) => _setData(
        path: APIPath.job(uid, 'job_ab'),
        data: job.toMap(),
      );

  @override
  Stream<List<Job>> jobsStream() {
    final path = APIPath.jobs(uid);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map(
          (event) {
            final data = event.data();
            return Job(
              name: data['name'],
              ratePerHour: data['ratePerHour'],
            );
          },
        ).toList());
  }

  Future<void> _setData(
      {String? path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path!);
    await reference.set(data);
  }
}

//CVj5gOICyrSMVXyCWKfXIPcWCks1
