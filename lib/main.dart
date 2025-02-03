import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_app/router/router.dart';
import 'package:photo_app/storage/token_storage.dart';
import 'package:photo_app/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await TokenStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PhotoApp',
      theme: darkTheme,
      routes: routes,
    );
  }
}
