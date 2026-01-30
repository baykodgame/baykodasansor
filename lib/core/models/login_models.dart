class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}

class LoginResponse {
  final bool status;
  final String? token;
  final String? role;
  final int? companyId;
  final String? message;

  LoginResponse({
    required this.status,
    this.token,
    this.role,
    this.companyId,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json["status"] ?? false,
      token: json["data"]?["token"],
      role: json["data"]?["user"]?["role"],
      companyId: json["data"]?["user"]?["company_id"],
      message: json["message"],
    );
  }
}
