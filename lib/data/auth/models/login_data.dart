import 'package:hive/hive.dart';

part 'login_data.g.dart';

@HiveType(typeId: 0)
class LoginData extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final bool rememberMe;

  LoginData({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'rememberMe': rememberMe,
    };
  }

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      rememberMe: json['rememberMe'] ?? false,
    );
  }
}
