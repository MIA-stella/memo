import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memo/pages/top_page.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.grey),
      darkTheme: ThemeData.dark(),
      home: const TopPage(title: '過去問一覧'),
    );
  }
}



