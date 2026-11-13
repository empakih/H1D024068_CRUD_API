class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;
  String? message;

  Login({
    this.code,
    this.status,
    this.token,
    this.userID,
    this.userEmail,
    this.message,
  });

  factory Login.fromJson(Map<String, dynamic> obj) {
    if (obj['status'] == true && obj['data'] is Map) {
      final data = obj['data'] as Map<String, dynamic>;
      final user = data['user'] is Map ? data['user'] as Map<String, dynamic> : null;

      return Login(
        code: obj['code'],
        status: true,
        token: data['token']?.toString(),
        userID: user != null
            ? (user['id'] is int
                ? user['id'] as int
                : int.tryParse(user['id'].toString()))
            : null,
        userEmail: user != null ? user['email']?.toString() : null,
      );
    } else {
      // Saat login gagal, backend mengirim data bertipe String pesan error:
      // "Email tidak ditemukan" atau "Password tidak valid"
      return Login(
        code: obj['code'],
        status: false,
        message: obj['data']?.toString() ?? "Email atau Password salah!",
      );
    }
  }
}
