import 'package:photo_app/config/env.dart';

class StagingConfig extends EnvConfig {
  @override
  String get apiUrl => 'https://api.your-app.com';

  @override
  String get sentryDsn => 'https://xyz@sentry.io/123';

  @override
  bool get enableAnalytics => true;
}
