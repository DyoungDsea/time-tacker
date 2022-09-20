
import 'package:flutter_1/app/home/models/models.dart';
import 'package:flutter_1/services/api_path.dart';
import 'package:flutter_1/services/firestore_services.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}
String idFromDate() => DateTime.now().toIso8601String();
class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> createJob(Job job) => _service.setData(
        path: APIPath.job(uid, idFromDate()),
        data: job.toMap(),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );
}
