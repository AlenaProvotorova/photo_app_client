import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_app/config/dev.dart';
import 'package:photo_app/config/env.dart';
import 'package:photo_app/config/prod.dart';
import 'package:photo_app/config/staging.dart';
import 'package:photo_app/core/router/router.dart';
import 'package:photo_app/core/utils/client_storage.dart';
import 'package:photo_app/core/utils/token_storage.dart';
import 'package:photo_app/core/theme/theme.dart';
import 'package:photo_app/service_locator.dart';

class Config {
  static late EnvConfig _instance;

  static EnvConfig get current => _instance;

  static void initialize(String env) {
    switch (env) {
      case 'prod':
        _instance = ProdConfig();
        break;
      case 'staging':
        _instance = StagingConfig();
        break;
      default:
        _instance = DevConfig();
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();
  await Hive.initFlutter();
  await TokenStorage.init();
  await ClientStorage.init();

  const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  Config.initialize(env);

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
