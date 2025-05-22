class AuthResult {
  final String id;
  final String username;
  final String? fullName;
  final String? token;
  final String? refreshToken;
  final String? role;

  AuthResult({
    required this.id,
    required this.username,
    this.fullName,
    this.token,
    this.refreshToken,
    this.role,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      id: json['id'],
      username: json['username'],
      fullName: json['fullName'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      role: json['role'],
    );
  }
}
