class SignUpReqParams {
  final String name;
  final String email;
  final String password;

  SignUpReqParams({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
