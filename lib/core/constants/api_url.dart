import 'environment.dart';

class ApiUrl {
  static String get baseURL => EnvironmentConfig.apiBaseURL;

  static const String signUp = 'user';
  static const String signIn = 'auth/login';

  static const String userProfile = 'user/profile';
  static const String users = 'user/users';

  static const String folders = 'folders';
  static const String files = 'files';
  static const String filesBatch = 'files/batch';
  static const String filesFolder = 'files/folder';

  static const String clients = 'clients';

  static const String sizes = 'sizes';
  static const String orders = 'orders';

  static const String folderSettings = 'folder-settings';

  static const String watermarks = 'watermarks';
}
