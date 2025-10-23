import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_app/core/router/router.dart';
import 'package:photo_app/core/utils/client_storage.dart';
import 'package:photo_app/core/utils/token_storage.dart';
import 'package:photo_app/core/theme/theme.dart';
import 'package:photo_app/data/auth/services/login_data_service.dart';
import 'package:photo_app/data/auth/models/login_data.dart';
import 'package:photo_app/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();
  await Hive.initFlutter();

  Hive.registerAdapter(LoginDataAdapter());

  await TokenStorage.init();
  await ClientStorage.init();
  await LoginDataService.init();

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
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'PhotoApp',
      theme: darkTheme,
    );
  }
}
