import 'package:photo_app/config/env.dart';

class DevConfig extends EnvConfig {
  @override
  String get apiUrl => 'https://api.dev.your-app.com';

  @override
  String get sentryDsn => ''; // Пусто для dev

  @override
  bool get enableAnalytics => false;
}
