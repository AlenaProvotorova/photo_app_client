class ApiUrl {
  static String baseURL = const String.fromEnvironment(
    'API_BASE_URL',
    // defaultValue: 'https://photoappserver-production.up.railway.app/api/',
    defaultValue: 'http://127.0.0.1:3000/api/',
  );

  static const String signUp = 'user';
  static const String signIn = 'auth/login';

  static const String userProfile = 'user/profile';

  static const String folders = 'folders';
  static const String files = 'files';

  static const String clients = 'clients';

  static const String sizes = 'sizes';
  static const String orders = 'orders';

  static const String folderSettings = 'folder-settings';

  static const String watermarks = 'watermarks';
}
