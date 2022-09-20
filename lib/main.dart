import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_1/app/landing_page.dart';
import 'package:flutter_1/services/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context)=>Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DyoungDsea',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home:const LandingPage(),
      ),
    );
  }
}
