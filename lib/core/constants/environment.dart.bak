enum Environment {
  development,
  production,
  staging,
}

class EnvironmentConfig {
  static const Environment _currentEnvironment = Environment.development;

  static Environment get current => _currentEnvironment;

  static bool get isDevelopment =>
      _currentEnvironment == Environment.development;
  static bool get isProduction => _currentEnvironment == Environment.production;
  static bool get isStaging => _currentEnvironment == Environment.staging;

  // API URLs for different environments
  static const String _developmentUrl = 'http://127.0.0.1:3000/api/';
  static const String _stagingUrl =
      'https://photoappserver-staging.up.railway.app/api/';
  static const String _productionUrl =
      'https://photoappserver-production.up.railway.app/api/';

  // Frontend URLs for different environments
  static const String _developmentFrontendUrl = 'http://localhost:3000';
  static const String _stagingFrontendUrl = 'https://fastselect.ru';
  static const String _productionFrontendUrl = 'https://fastselect.ru';

  static String get apiBaseURL {
    switch (_currentEnvironment) {
      case Environment.development:
        return _developmentUrl;
      case Environment.staging:
        return _stagingUrl;
      case Environment.production:
        return _productionUrl;
    }
  }

  static String get frontendBaseURL {
    switch (_currentEnvironment) {
      case Environment.development:
        return _developmentFrontendUrl;
      case Environment.staging:
        return _stagingFrontendUrl;
      case Environment.production:
        return _productionFrontendUrl;
    }
  }

  // Request headers for API calls
  static Map<String, String> get requestHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Request timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
