import 'package:flutter_1/app/home/models/models.dart';
import 'package:flutter_1/services/api_path.dart';
import 'package:flutter_1/services/firestore_services.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job>> jobsStream();
}

String idFromDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) => _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) => _service.deleteData(
        path: APIPath.job(uid, job.id),
       
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, id) => Job.fromMap(data, id),
      );
}
